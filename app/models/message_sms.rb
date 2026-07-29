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

class MessageSms < Message
  MESSAGE_SEND_INFO = Settings.submail.message
  after_create :send_message

  def send_message
    logger.info '开始发送短信'
    message_config = {}
    message_config["appid"] = MESSAGE_SEND_INFO.appid
    message_config["appkey"] = MESSAGE_SEND_INFO.appkey
    message_config["signtype"] = "md5"
    messagexsend = Submail::MessageXSend.new(message_config)
    logger.info "参数 #{message_config}"
    JSON.parse(content).each do |key, value|
      messagexsend.add_var key, value
    end
    messagexsend.add_to to
    messagexsend.set_project template_id
    logger.info "request content:#{content}, to: #{to}, template_id: #{template_id}"
    response = messagexsend.format_response
    logger.info "response #{response}"
    self.update response
  end

  def logger
    Logger.new 'log/sms.log'
  end
end
