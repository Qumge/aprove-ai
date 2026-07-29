# == Schema Information
#
# Table name: messages
#
#  id          :integer          not null, primary key
#  code        :string(255)
#  content     :string(255)
#  fee         :integer
#  from        :string(255)
#  msg         :string(255)
#  status      :string(255)
#  to          :string(255)
#  type        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  send_id     :string(255)
#  template_id :string(255)
#

class MessageMail < Message
end
