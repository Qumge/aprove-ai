require 'net/http'
require 'json'
require 'digest/md5'
require 'digest/sha1'
require 'json'
class Submail::Base
  def http_get(url)
    Net::HTTP.get(URI(url))
  end
  def http_post(url,postdata)
    Net::HTTP.post_form(URI(url),postdata).body
  end
  def get_timestamp()
    json = JSON.parse http_get("https://api.submail.cn/service/timestamp.json")
    json["timestamp"]
  end

  def create_signatrue(request,config)
    appkey = config["appkey"]
    appid = config["appid"]
    signtype = config["signtype"]
    request["sign_type"] = signtype
    keys = request.keys.sort
    values = []
    keys.each do |k|
      values << "%s=%s"%[k,request[k]]
    end
    signstr = "%s%s%s%s%s"%[appid,appkey, values.join('&'),appid, appkey]
    puts signstr
    if signtype == "normal"
      appkey
    elsif signtype == "md5"
      Digest::MD5.hexdigest(signstr)
    else
      Digest::SHA1.hexdigest(signstr)
    end
  end

  def format_response
    {status: '', send_id: '', fee: '', code: '', msg: ''}
  end
end