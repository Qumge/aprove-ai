class Submail::MessageXSend < Submail::Base
  MESSAGE_SEND_INFO = Settings.submail.message
  def initialize(config)
    @to = []
    @addressbook = []
    @project = ""
    @vars = {}
    @config = config
  end
  def add_to(address)
    @to << address
  end
  def add_addressbook(addressbook)
    @addressbook << addressbook
  end
  def set_project(project)
    @project = project
  end
  def add_var(key, value)
    @vars[key] = value
  end

  def build_request
    request = {}
    if @to.length != 0
      request["to"] = @to.join(",")
    end
    if @addressbook.length != 0
      request["addressbook"] = @addressbook.join(",")
    end
    if @project != ""
      request["project"] = @project
    end
    if @vars.length != 0
      request["vars"] = JSON.generate @vars
    end
    request
  end

  def message_xsend
    request = build_request
    url = MESSAGE_SEND_INFO.message_x_send_url
    request["appid"] = @config["appid"]
    request["timestamp"] = get_timestamp
    request["signature"] = create_signatrue(request, @config)
    http_post(url, request)
  end

  def format_response
    response = JSON.parse message_xsend
    { status: response['status'], send_id: response['send_id'], fee: response['fee'], code: response['code'], msg: response['code'] }
  end
end
