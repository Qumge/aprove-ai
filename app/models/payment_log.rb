# == Schema Information
#
# Table name: payment_logs
#
#  id         :integer          not null, primary key
#  amount     :float(24)
#  payment_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  order_id   :integer
#  user_id    :integer
#

class PaymentLog < ActiveRecord::Base
  belongs_to :user
  belongs_to :order
  validates_numericality_of :amount
  validates_presence_of :payment_at, :amount
  after_save :compute_payment

  def compute_payment
    self.order.compute_payment
  end

end
