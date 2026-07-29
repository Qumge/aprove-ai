# == Schema Information
#
# Table name: delivers
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  number     :string(255)
#  phone      :string(255)
#  phone_to   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  order_id   :integer
#

class Deliver < ActiveRecord::Base
  validates_presence_of :name, :number, :phone, :phone_to, :order_id
  after_create :send_message
  MESSAGE_SEND_INFO = Settings.submail.message
  def send_message
    MessageSms.create to: phone_to, content: {name: name, number: number, phone: phone}.to_json, template_id: MESSAGE_SEND_INFO.template_id
  end
end
