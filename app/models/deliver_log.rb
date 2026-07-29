# == Schema Information
#
# Table name: deliver_logs
#
#  id         :integer          not null, primary key
#  amount     :float(24)
#  deliver_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  order_id   :integer
#  user_id    :integer
#

class DeliverLog < ActiveRecord::Base
  belongs_to :order
  has_one :deliver_file, -> {where(model_type: 'deliver')}, class_name: 'Attachment', foreign_key: :model_id
  validates_presence_of :amount, :deliver_at
  belongs_to :user

  after_save :compute_deliver_amount

  def compute_deliver_amount
    self.order.do_deliver! if self.order.may_do_deliver?
    self.order.update last_deliver_at: self.deliver_at
    self.order.compute_deliver_amount
  end
end
