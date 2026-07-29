# == Schema Information
#
# Table name: audits
#
#  id          :integer          not null, primary key
#  content     :string(255)
#  from_status :string(255)
#  model_type  :string(255)
#  status      :string(255)
#  to_status   :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  model_id    :integer
#  user_id     :integer
#

class Audit < ActiveRecord::Base
  belongs_to :project,  foreign_key: :model_id
  scope :project_audit, -> {where(model_type: 'Project')}
  belongs_to :user

  PROJECT = []

  MODEL_TYPES = {
      Project: '立项',
      Order: '订单(特价、样品)',
      Agent: '代理商',
      Invoice: '开票'
  }


  def model
    model_type.constantize.find_by id: model_id
  end

  def model_show_name
    case model.class.name
    when 'Project'
      model.name
    when 'Order'
      model.no
    when 'Agent'
      model.name
    when 'Invoice'
      model.invoice_no
    end
  end


  def get_model_type
    model_type == 'Order' ? (model.order_type == 'bargains' ? '特价' : '样品') : MODEL_TYPES[model_type.to_sym]
  end

end
