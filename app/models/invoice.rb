# == Schema Information
#
# Table name: invoices
#
#  id             :integer          not null, primary key
#  amount         :float(24)
#  applied_at     :datetime
#  apply_at       :datetime
#  invoice_status :string(255)
#  no             :string(255)
#  sended_at      :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  project_id     :integer
#  user_id        :integer
#

class Invoice < ActiveRecord::Base
  include AASM
  has_and_belongs_to_many :orders, join_table: "order_invoices"
  has_many :order_invoices
  belongs_to :project
  belongs_to :user
  has_many :audits, -> {where(model_type: 'Invoice')}, foreign_key: :model_id
  has_one :invoice_file, -> {where(model_type: 'invoice')}, class_name: 'Attachment', foreign_key: :model_id
  validates_presence_of :amount
  after_create :set_no

  STATUS = {wait: '新建', apply: '已申请', applied: '已通过申请', failed: '审核失败', sended: '已开票'}
  aasm :invoice_status do
    state :wait, :initial => true
    state :apply, :applied, :failed, :sended
    #申请
    event :do_apply do
      transitions :from => [:wait, :failed], :to => :apply, :after => Proc.new {create_apply_notice; set_apply_at}
    end

    event :do_failed do
      transitions :from => [:apply], :to => :failed, :after => Proc.new {create_failed_notice}
    end

    event :do_applied do
      transitions :from => [:apply], :to => :applied, :after => Proc.new {create_applied_notice; set_applied_at}
    end

    event :do_sended do
      transitions :from => [:applied], :to => :sended, :after => Proc.new {create_sended_notice; set_sended_at}
    end

  end

  def can_invoice_orders
    project = self.project
    invoice_orders = project.orders.where(order_status: 'sign')
    if project.order_invoices.present? && (project.order_invoices.collect{|o| o.order_id} - self.order_invoices.collect{|o| o.order_id}).present?
      invoice_orders = invoice_orders.where('orders.id not in (?)', (project.order_invoices.collect{|o| o.order_id} - self.order_invoices.collect{|o| o.order_id}))
    end
    invoice_orders
  end

  def invoice_no
    'NO.' + id.to_s.rjust(6, '0')
  end

  def set_no
    self.update no: invoice_no
  end

  def can_edit?
    ['wait', 'failed'].include? self.invoice_status
  end

  def create_apply_notice
    User.joins(:roles).where('roles.desc in (?)', ['normal_admin', 'group_admin']).each do |user|
      Notice.create_notice "invoice_need_audit".to_sym, self.id, user.id
    end
  end

  def create_failed_notice
    Notice.create_notice "invoice_failed".to_sym, self.id, self.user_id
  end

  def create_applied_notice
    Notice.create_notice "invoice_applied".to_sym, self.id, self.user_id
    User.joins(:roles).where('roles.desc in (?)', ['normal_admin', 'group_admin']).each do |user|
      Notice.create_notice "invoice_need_send".to_sym, self.id, user.id
    end
  end

  def create_sended_notice
    Notice.create_notice "invoice_sended".to_sym, self.id, self.user_id
  end

  def total_price
    total_price = 0
    self.orders.each do |order|
      total_price += order.real_total_price
    end
    total_price.ceil 2
  end

  def get_status
    Invoice::STATUS[self.invoice_status.to_sym]
  end

  def set_apply_at
    self.update apply_at: DateTime.now
  end

  def set_applied_at
    self.update applied_at: DateTime.now
  end

  def set_sended_at
    self.update sended_at: DateTime.now
  end

  def audit_failed_reason
    audit = self.audits.where(to_status: 'failed').last
    audit&.content
  end

  def owner
    self.project.owner
  end

  class << self
    def search_conn params
      invoices = self.joins(:project, :user)
      if params[:invoice_status].present?
        invoices = invoices.where(invoice_status: params[:invoice_status])
      end

      if params[:table_search].present?
        invoices = invoices.where('projects.name like ? or invoices.no like ? or users.name like ?', "%#{params[:table_search]}%", "%#{params[:table_search]}%", "%#{params[:table_search]}%")
      end
      invoices
    end

  end
end
