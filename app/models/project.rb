# == Schema Information
#
# Table name: projects
#
#  id                :integer          not null, primary key
#  a_name            :string(255)
#  address           :string(255)
#  approval_time     :datetime
#  butt_name         :string(255)
#  butt_phone        :string(255)
#  butt_title        :string(255)
#  category          :string(255)
#  city              :string(255)
#  constructor       :string(255)
#  constructor_phone :string(255)
#  cost              :string(255)
#  cost_phone        :string(255)
#  deleted_at        :datetime
#  deliver_amount    :float(24)
#  design            :string(255)
#  design_phone      :string(255)
#  estimate          :integer
#  name              :string(255)
#  need_payment      :float(24)        default(0.0)
#  payment           :float(24)        default(0.0)
#  payment_percent   :float(24)
#  project_status    :string(255)
#  purchase          :string(255)
#  purchase_phone    :string(255)
#  settling          :string(255)
#  settling_phone    :string(255)
#  shipment_end      :datetime
#  step              :integer          default(0)
#  step_status       :string(255)
#  strategic         :boolean
#  supervisor        :string(255)
#  supervisor_phone  :string(255)
#  supplier_type     :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  agency_id         :integer
#  category_id       :integer
#  company_id        :integer
#  contract_id       :integer
#  create_id         :integer
#  owner_id          :integer
#
# Indexes
#
#  index_projects_on_deleted_at  (deleted_at)
#

class Project < ActiveRecord::Base
  acts_as_paranoid
  include AASM
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  belongs_to :category
  belongs_to :company
  belongs_to :create_user, class_name: 'User', foreign_key: :create_id
  has_one :audit, -> {where(model_type: 'Project')}, foreign_key: :model_id
  after_create :create_project_manager_notice
  validates_presence_of :name, :company_id, :category_id, :address, :city, :supplier_type
  validates_numericality_of :estimate, if: Proc.new{|p| p.estimate.present?}
  validates_uniqueness_of :name
  has_one :project_contract, -> {where(model_type: 'contract')}, class_name: 'Attachment', foreign_key: :model_id
  has_one :advance, -> {where(model_type: 'advance')}, class_name: 'Attachment', foreign_key: :model_id
  has_one :plate, -> {where(model_type: 'plate')}, class_name: 'Attachment', foreign_key: :model_id
  has_many :payments, -> {where(model_type: 'payment')}, class_name: 'Attachment', foreign_key: :model_id
  has_many :settlements, -> {where(model_type: 'settlement')}, class_name: 'Attachment', foreign_key: :model_id
  has_many :attachments, foreign_key: :model_id
  has_one :bond, -> {where(model_type: 'bond')}, class_name: 'Attachment', foreign_key: :model_id
  has_many :orders
  has_many :sample_orders, -> {where(order_type: 'sample')}, class_name: 'Order', foreign_key: :project_id
  has_many :normal_orders, -> {where(order_type: 'normal')}, class_name: 'Order', foreign_key: :project_id
  has_many :bargains_orders, -> {where(order_type: 'bargains')}, class_name: 'Order', foreign_key: :project_id
  has_many :default_orders, -> {where(order_type: ['normal', 'bargains'])}, class_name: 'Order', foreign_key: :project_id
  #belongs_to :contract
  has_many :invoices
  belongs_to :agent, foreign_key: :agency_id
  has_one :report
  has_many :audits, -> {where(model_type: 'Project')}, foreign_key: :model_id
  has_and_belongs_to_many :contracts, join_table: "projects_contracts"
  #
  STATUS = {wait: '待审批', project_manager_audit: '项目经理已审批', regional_audit: '大区经理已审批', active: '进行中', finish: '已完结', overdue: '逾期', failed: '审核失败'}
  aasm :project_status do
    state :wait, :initial => true
    state :project_manager_audit, :regional_audit, :active, :finish, :overdue, :failed

    event :do_apply do
      transitions :from => :failed, :to => :wait, :after => Proc.new {create_project_manager_notice }
    end

    #项目经理审批
    event :do_project_manager_audit do
      transitions :from => :wait, :to => :project_manager_audit, :after => Proc.new {create_audit_notice }
    end
    # 大区经理审批
    event :do_regional_manager_audit do
      transitions :from => :project_manager_audit, :to => :regional_audit, :after => Proc.new {create_admin_audit_notice }
    end

    # 后勤管理审批
    event :do_group_admin_audit do
      transitions :from => :regional_audit, :to => :active, :after => Proc.new {create_active_notice; set_approval_time }
    end

    #
    event :do_finish do
      transitions :from => :active, :to => :finish
    end

    event :do_overdue do
      transitions :from => :active, :to => :overdue
    end

    event :do_failed do
      transitions :from => [:wait, :project_manager_audit, :regional_audit], :to => :failed, :after => Proc.new {create_failed_notice }
    end
  end

  aasm :step_status do
    state :contract, :initial => true
    state :advance, :pattern, :plate, :detail, :order, :process_payment, :shipment_ended, :settlement, :payment, :bond, :confirm, :done

    event :done_contract do
      transitions :from => :contract, :to => :advance do
        guard do
          project_contract.present?
        end
      end
    end

    event :done_advance do
      transitions :from => :advance, :to => :pattern do
      end
    end

    event :done_pattern do
      transitions :from => :pattern, :to => :plate
    end

    event :done_plate do
      transitions :from => :plate, :to => :detail
    end

    event :done_detail do
      transitions :from => :detail, :to => :order
    end

    event :done_order do
      transitions :from => :order, :to => :process_payment do
        guard do
          true
          # 判断是否可以完结订单 TODO
        end
      end
    end


    event :done_process_payment do
      transitions :from => :process_payment, :to => :shipment_ended  do
        guard do
          # 判断是否可以完结进度款申请 TODO
          true
        end
      end
    end

    event :done_shipment_ended do
      transitions :from => :shipment_ended, :to => :settlement , :after => Proc.new {set_shipment_end }
    end

    event :done_settlement do
      transitions :from => :settlement, :to => :payment  do
        guard do
          # 判断是否可以完结结算款申请 TODO
          true
        end
      end
    end

    event :done_payment do
      transitions :from => :payment, :to => :bond  do
        guard do
          # 判断是否可以回款 TODO
          true
        end
      end
    end

    event :done_bond do
      transitions :from => :bond, :to => :confirm  do
        guard do
          # 判断是否可以完结保证金 TODO
          true
        end
      end
    end

    event :done_confirm do
      transitions :from => :confirm, :to => :done, :after => Proc.new{do_finish!}  do
        guard do
          # 判断是否可以项目结清 TODO
          true
        end
      end
    end

  end

  # 根据审核表获取当前的审核状态
  def status
    I18n.t("projects.statuses.#{project_status}", default: STATUS[project_status.to_sym])
  end

  #
  def agency_name
    agent.present? ? agent.name : '自营'
  end

  #已经申请的order
  def order_invoices
    OrderInvoice.includes(:order).where('orders.project_id = ?', self.id).references(:order)
  end


  def can_invoice_orders
    # 已签收的订单可以申请开票
    invoice_orders = self.orders.where(order_status: 'sign')
    invoice_orders = invoice_orders.where('orders.id not in (?)', self.order_invoices.collect{|o| o.order_id}) if self.order_invoices.present?
    invoice_orders
  end

  def sales
    # 战略合同价格
    if contract.present?
      contract.sales
    else
      #代理商特价
      if agent.present? && agent.sales.present?
        agent.sales
      else
        #正常价格
        Sale.default_sales
      end
    end
  end

  # 判断是否可查看当前步骤
  def can_view? step
    steps = [:contract, :advance, :pattern, :plate, :detail, :order, :process_payment, :shipment_ended, :settlement, :payment, :bond, :confirm, :done]
    # 当前进度大于步骤 可见
    steps.index(self.step_status.to_sym) >= steps.index(step.to_sym)
  end

  # 判断是否可以操作
  def can_do? step
    can_view? step
    # step = step.is_a?(String) ? step.to_sym : step
    # self.step_status.to_sym == step
    # true
  end

  # 判断是否可以操作
  def can_do_next? step
    step = step.is_a?(String) ? step.to_sym : step
    self.step_status.to_sym == step
  end

  def audit_failed_reason
    audit = self.audits.where(to_status: 'failed').last
    audit&.content
  end

  # 订单总金额
  def compute_need_payment
    amount = 0
    self.orders.where(order_status: ['deliver', 'sign']).each do |order|
      amount += order.real_total_price.to_f
    end
    amount
    self.update need_payment: amount
    compute_payment_percent
  end

  # 已经回款金额
  def compute_payment
    amount = 0
    self.orders.each do |order|
      amount += order.payment.to_f
    end
    self.update payment: amount
    compute_payment_percent
  end

  # 已发货金额
  def compute_deliver_amount
    amount = 0
    self.orders.each do |order|
      amount += order.deliver_amount.to_f
    end
    self.update deliver_amount: amount
    compute_payment_percent
  end

  # 计算回款百分比
  def compute_payment_percent
    self.update payment_percent: self.payment/self.deliver_amount if self.deliver_amount.to_f > 0
  end


  def city_name
    ChinaCity.get self.city if self.city.present?
  end

  # 用于判断预付款 进度款 结算款
  def step_end? step
    steps = [:contract, :advance, :pattern, :plate, :detail, :order, :process_payment, :shipment_ended, :settlement, :payment, :bond, :confirm, :done]
    # 当前进度大于步骤 可见
    file = step == 'settlement' ? 'settlements' : step
    (steps.index(self.step_status.to_sym) > steps.index(step.to_sym)) || self.send(file).present?
  end


  #判断预是否预付款到期
  def advance_overdue?
    flag = false
    unless step_end? 'advance'
      # 到期时间
      days = contract&.advance_time.present? ? contract.advance_time : 7
      flag = approval_time.present? && (approval_time + days.days) < DateTime.now
    end
    flag
  end

  #判断预是否结算款到期
  def settlement_overdue?
    flag = false
    unless step_end? 'settlement'
      # 到期时间
      days = contract&.settlement_time.present? ? contract.settlement_time : 90
      flag = shipment_end.present? && (shipment_end + days.days) < DateTime.now
    end
    flag
  end

  #判断预是尾款是否到期
  def bond_overdue?
    flag = false
    unless step_end? 'bond'
      # 到期时间
      days = contract&.tail_time.present? ? contract.tail_time : 90
      flag = shipment_end.present? && (shipment_end + days.days) < DateTime.now
    end
    flag
  end

  def check_overdue
    create_money_notice 'advance' if advance_overdue?
    create_money_notice 'settlement' if settlement_overdue?
    create_money_notice 'bond' if bond_overdue?
  end

  def contract
    self.contracts&.first
  end

  def contract_sales
    array = []
    self.contracts.each do |contract|
      contract.sales.each do |sale|
        array << sale
      end
    end
    array
  end

  class << self
    def search_conn params
      projects = self.all
      if params[:table_search].present?
        projects = projects.joins(:owner).where('projects.name like ? or projects.a_name like ? or users.name like ?', "%#{params[:table_search]}%", "%#{params[:table_search]}%", "%#{params[:table_search]}%")
      end
      if params[:project_status].present?
        projects = projects.where(project_status: params[:project_status])
      end
      if params[:payment_percent].present?
        from = 0
        to = 10000
        case params[:payment_percent]
        when 'danger'
          to = 0.25
        when 'warning'
          from = 0.25
          to = 0.5
        when 'blue'
          from = 0.5
          to = 0.75
        when 'info'
          from = 0.75
          to = 0.95
        when 'green'
          from = 0.95
        end
        projects = projects.where('projects.payment_percent >= ? and projects.payment_percent < ?', from, to)
      end
      projects
    end

    def check_overdue
      logger.info "##########{DateTime.now} 开始项目延期检测#################"
      Project.all.each do |project|
        logger.info "############开始检测项目: #{project.name}############"
        project.check_overdue
      end
      logger.info "##########{DateTime.now} 结束项目延期检测#################"
    end

    def logger
      Logger.new 'log/overdue.log'
    end


    def test_data number=20, begin_date=DateTime.now-10.days, end_date=DateTime.now+2.days
      1.step(number).each do |n|
        Project.create category: Category.all.sample, contract: Contract.all.sample, owner: User.all.sample,
                       company: Company.all.sample, create_user: User.all.sample, name: "数据测试_#{n}",
                       address: '协信中心', city: '440300', supplier_type: '甲指'
      end
      begin_date.step(end_date).each do |date|
        Project.all.each do |project|
          1.step(5).each do |number|
            op = OrderProduct.new product: Product.all.sample, number: (rand 20)
            order = Order.new project: project, order_type: 'normal', user: User.all.sample, order_status: :wait, order_products: [op]
            if order.save
              if rand(20) > 5
                p "order: #{ order.id}do place"
                order.do_place!
                order.update applied_at: date
                if rand(20) > 5
                  p "order: #{ order.id} do deliver"
                  order.do_deliver!
                  order.update deliver_at: (order.applied_at + rand(2).days)
                  # if rand(20) > 5
                  #   order.update payment: (rand(20)/20.0)*order.total_price, payment_at: (order.deliver_at + rand(2).days)
                  # end
                end
              end
            else
              p order.errors
            end
          end
        end

        User.all.each do |user|
          if rand(20) > 10
            Cost.create purpose: 'test', user: user, amount: rand(2000), occur_time: date
          end
        end
      end
    end

    def change_contract_to_contracts
      Project.all.each do |project|
        project.contracts << project.contract unless project.contracts.include? project.contract
        project.save
      end
    end
  end




  private

  #设置结算款时间
  def set_shipment_end
    self.update shipment_end: DateTime.now
  end

  # 审批成功生成审批时间
  def set_approval_time
    self.update approval_time: DateTime.now
  end

  # 通知项目经理审批
  def create_project_manager_notice
    if owner.present? && owner.organization.present?
      owner.organization.users.joins(:roles).where('roles.desc = ?', 'project_manager').each do |user|
        Notice.create_notice :project_need_audit, self.id, user.id
      end
    end
  end

  # 通知大区总监审批
  def create_audit_notice
    if owner.present? && owner.organization.present? && owner.organization.parent.present?
      owner.organization.parent.users.joins(:roles).where('roles.desc = ?', 'regional_manager').each do |user|
        Notice.create_notice :project_need_audit, self.id, user.id
      end
    end
  end

  # 通知后勤审批
  def create_admin_audit_notice
    User.joins(:roles).where('roles.desc = ?', 'group_admin').each do |user|
      Notice.create_notice :project_need_audit, self.id, user.id
    end
  end

  # 通知立项失败
  def create_failed_notice
    Notice.create_notice :project_failed_audit, self.id, owner_id
  end

  # 通知立项成功
  def create_active_notice
    Notice.create_notice :project_audited, self.id, owner_id
  end

  # 通知付款信息未到
  def create_money_notice type
    Notice.create_notice "#{type}_overdue".to_sym, self.id, owner_id
  end





end
