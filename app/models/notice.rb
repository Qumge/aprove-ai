# == Schema Information
#
# Table name: notices
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  model_type :string(255)
#  readed     :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  model_id   :integer
#  user_id    :integer
#

class Notice < ActiveRecord::Base
  belongs_to :order, foreign_key: 'model_id'
  belongs_to :project, foreign_key: 'model_id'
  belongs_to :agent, foreign_key: 'model_id'
  belongs_to :invoice, foreign_key: 'model_id'
  TYPES = {
      project_need_audit: '有一个新立项的项目需要审核',
      project_audited: '您立项的的项目已经通过审核',
      project_failed_audit: '您立项的项目未通过审核',
      sample_order_need_audit: '有一个样品申请需要审核',
      sample_order_audited: '您的样品申请已经通过审核',
      sample_order_failed_audit: '您的样品申请未通过审核',
      bargains_order_need_audit: '有一个特价申请需要审核',
      bargains_order_audited: '您的特价申请已经通过审核',
      bargains_order_failed_audit: '您的特价申请未通过审核',
      order_deliver: '有新的订单需要处理，请及时发货',
      order_sign: '您的订单已经发货，请注意查收',
      agent_need_audit: '有一个代理商申请需要审核',
      agent_audited: '您申请的代理商已经通过审核',
      agent_failed_audit: '你申请的代理商未通过审核',
      invoice_need_audit: '新的开票申请需要审批',
      invoice_failed: '开票申请审核未通过',
      invoice_applied: '开票申请已通过审核',
      invoice_need_send: '开票申请需要安排开票快递',
      invoice_sended: '开票快递已发出',
      advance_overdue: '有一个项目预付款超期了',
      settlement_overdue: '有一个结算款超期了',
      bond_overdue: '有一个项目尾款超期了',
      order_payment_overdue: '有一个订单进度款超期了（未回款或回款不足）'
  }


  class << self
    def create_notice type, id, user_id
      Notice.create model_type: type, model_id: id, content: TYPES[type], user_id: user_id
    end
  end


end
