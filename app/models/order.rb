# == Schema Information
#
# Table name: orders
#
#  id              :integer          not null, primary key
#  applied_at      :datetime
#  apply_at        :datetime
#  deleted_at      :datetime
#  deliver_amount  :float(24)
#  desc            :string(255)
#  last_deliver_at :datetime
#  last_payment_at :datetime
#  no              :string(255)
#  order_status    :string(255)
#  order_type      :string(255)
#  payment         :float(24)        default(0.0)
#  payment_percent :float(24)
#  total_price     :float(24)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  factory_id      :integer
#  payment_id      :integer
#  project_id      :integer
#  user_id         :integer
#
# Indexes
#
#  index_orders_on_deleted_at  (deleted_at)
#

class Order < ActiveRecord::Base
  acts_as_paranoid
  include AASM
  belongs_to :project
  belongs_to :factory
  has_many :order_products, dependent: :destroy
  has_and_belongs_to_many :products, join_table: 'order_products'
  has_many :order_invoices
  has_many :payment_logs
  belongs_to :user
  after_create :set_no
  has_and_belongs_to_many :invoices, join_table: "order_invoices"
  has_one :place_file, -> {where(model_type: 'place')}, class_name: 'Attachment', foreign_key: :model_id
  # has_many :sign_files, -> {where(model_type: 'sign')}, class_name: 'Attachment', foreign_key: :model_id
  has_many :audits, -> {where(model_type: 'Order')}, foreign_key: :model_id
  has_many :deliver_logs
  has_many :delivers
  has_one :sign_log
  has_one :fund_log
  # after_update :check_payment

  STATUS = {wait: '新订单', apply: '已申请', project_manager_audit: '项目经理已审核',
            regional_manager_audit: '大区经理已审核', normal_admin_audit: '后勤已审核',
            active: '已下单或申请成功', deliver: '已发货', sign: '已签收', fund: '请款', failed: '审核失败' }

  ORDER_TYPE = {sample: '样品', normal: '订单', bargains: '特价订单'}

  aasm :order_status do
    state :wait, :initial => true
    state :apply, :project_manager_audit, :regional_manager_audit, :normal_admin_audit, :active, :deliver, :sign, :fund,:failed

    #申请
    event :do_apply do
      transitions :from => [:wait, :failed], :to => :apply, :after => Proc.new {create_project_manager_audit_notice; set_apply_at}
    end

    # 下单
    event :do_place do
      transitions :from => [:wait, :failed], :to => :active, :after => Proc.new {create_deliver_notice; set_apply_at; set_applied_at }
    end

    # 发货
    event :do_deliver do
      transitions :from => :active, :to => :deliver, :after => Proc.new {create_sign_notice }
    end

    # 签收
    event :do_sign do
      transitions :from => :deliver, :to => :sign
    end

    # 签收
    event :do_fund do
      transitions :from => :sign, :to => :fund
    end

    # 项目经理审批
    event :do_project_manager_audit do
      transitions :from => :apply, :to => :project_manager_audit, :after => Proc.new {create_regional_manager_audit_notice }
    end

    # 大区审批
    event :do_regional_manager_audit do
      transitions :from => :project_manager_audit, :to => :regional_manager_audit, :after => Proc.new {create_normal_admin_audit_notice }
    end

    # 后勤审批
    event :do_normal_admin_audit do
      transitions :from => :regional_manager_audit, :to => :normal_admin_audit, :after => Proc.new {create_group_admin_audit_notice }
    end

    # 部门管理审批
    event :do_group_admin_audit do
      transitions :from => :normal_admin_audit, :to => :active, :after => Proc.new {create_active_notice; set_applied_at }
    end

    #审批失败
    event :do_failed do
      transitions :from => [:apply, :project_manager_audit , :regional_audit, :normal_admin_audit], :to => :failed, :after => Proc.new {create_failed_notice }
    end

  end

  def real_total_price
    amount = 0
    order_products.each do |p|
      amount += p.real_total_price.to_f
    end
    amount
  end

  def set_no
    self.no = 'NO.' + self.id.to_s.rjust(6, '0')
    self.save
  end

  def can_edit?
     self.wait? || self.failed?
  end

  def set_apply_at
    self.update apply_at: DateTime.now, total_price: real_total_price
  end

  def set_applied_at
    self.update applied_at: DateTime.now
  end

  def set_deliver_at
    self.update last_deliver_at: DateTime.now
  end

  # 通知项目经理审批
  def create_project_manager_audit_notice
    if project.owner.present? && project.owner.organization.present?
      project.owner.organization.users.joins(:roles).where('roles.desc = ?', 'project_manager').each do |user|
        Notice.create_notice "#{order_type}_order_need_audit".to_sym, self.id, user.id
      end
    end
  end

  # 通知大区审批
  def create_regional_manager_audit_notice
    if project.owner.present? && project.owner.organization.present? && project.owner.organization.parent.present?
      project.owner.organization.parent.users.joins(:roles).where('roles.desc = ?', 'regional_manager').each do |user|
        Notice.create_notice "#{order_type}_order_need_audit".to_sym, self.id, user.id
      end
    end
  end

  # 通知后勤审批
  def create_normal_admin_audit_notice
    User.joins(:roles).where('roles.desc = ?', 'normal_admin').each do |user|
      Notice.create_notice "#{order_type}_order_need_audit".to_sym, self.id, user.id
    end
  end

  # 通知管理审批
  def create_group_admin_audit_notice
    User.joins(:roles).where('roles.desc = ?', 'group_admin').each do |user|
      Notice.create_notice "#{order_type}_order_need_audit".to_sym, self.id, user.id
    end
  end

  # 通知申请成功 并通知发货
  def create_active_notice
    Notice.create_notice :order_audited, self.id, user_id
    create_deliver_notice
  end

  # 通知发货
  def create_deliver_notice
    User.joins(:roles).where('roles.desc = ?', 'normal_admin').each do |user|
      Notice.create_notice :order_deliver, self.id, user.id
    end
  end

  # 通知签收
  def create_sign_notice
    Notice.create_notice :order_sign, self.id, user_id
  end

  # 通知审核失败
  def create_failed_notice
    Notice.create_notice "#{order_type}_order_failed_audit".to_sym, self.id, user_id
  end

  # 获取当前订单状态
  def get_status
    STATUS[self.order_status.to_sym]
  end

  # 获取订单类别
  def get_order_type
    ORDER_TYPE[self.order_type.to_sym]
  end

  def get_place_name
    order_type == 'normal' ? '下单' : '申请'
  end

  def audit_failed_reason
    audit = self.audits.where(to_status: 'failed').last
    audit&.content
  end


  def owner
    self.project.owner
  end

  def compute_need_payment
    self.project.compute_need_payment
  end

  # def check_payment
  #   if self.payment_changed?
  #     self.compute_payment
  #     self.compute_percent
  #   end
  # end

  def compute_payment
    amount = 0
    self.payment_logs.each do |payment|
      amount += payment.amount
    end
    self.update payment: amount
    self.update payment_percent: amount / self.deliver_amount.to_f if self.deliver_amount.to_f > 0
    self.project.compute_payment
  end

  # def compute_percent
  #   if real_total_price.present?
  #     self.update_columns payment_percent: self.payment / self.real_total_price
  #   end
  # end

  def compute_deliver_amount
    amount = 0
    self.deliver_logs.each do |deliver|
      amount += deliver.amount.to_f
    end
    self.update deliver_amount: amount
    self.update payment_percent: self.payment / amount.to_f if amount.to_f > 0
    self.project.compute_deliver_amount
  end

  # 进度款是否到期
  def payment_overdue?
    flag = false
    # 已经发货
    if last_deliver_at.present?
      days = project&.contract&.process_time.present? ? project.contract.process_time : 45
      percent = Settings.need_payment_percent
      percent ||= 0.8
      flag = (last_deliver_at + days.days) < DateTime.now && payment.to_f < total_price.to_f * percent
    end
    flag
  end

  def check_overdue
    Notice.create_notice :order_payment_overdue, self.id, project.owner_id if self.payment_overdue?
  end


  class << self
    # 检索
    def search_conn params
      orders = Order.all
      if params[:order_status].present?
        orders = orders.where(order_status: params[:order_status])
      end
      if params[:factory_id].present?
        orders = orders.where(factory_id: params[:factory_id])
      end

      if params[:table_search].present?
        orders = orders.joins(:project, :user).where('projects.name like ? or orders.no like ? or users.name like ?', "%#{params[:table_search]}%", "%#{params[:table_search]}%", "%#{params[:table_search]}%")
      end
      orders
    end

    def check_overdue
      logger.info "##########{DateTime.now} 开始订单延期检测#################"
      Order.all.each do |order|
        logger.info "############开始检测项目: #{order.no}############"
        order.check_overdue
      end
      logger.info "##########{DateTime.now} 结束订单延期检测#################"
    end

    def logger
      Logger.new 'log/overdue.log'
    end
  end





end
