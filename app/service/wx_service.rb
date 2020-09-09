class WxService

  # 微信公众平台相关 API 集合
  # 微信公众平台开发文档：https://mp.weixin.qq.com/wiki?t=resource/res_main&id=mp1445241432
  def initialize
    @wx_config        = Rails.application.config_for(:wechat)
    @access_token_key = "ACCESS_TOKEN:#{@wechat_config[:app_id]}"
    @connection       = Faraday.new 'https://api.weixin.qq.com' do |faraday|
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
    end
  end

  # 获取 Access Token
  # 参考文档：https://mp.weixin.qq.com/wiki?t=resource/res_main&id=mp1421140183
  def access_token
    if $redis.exists @access_token_key
      JSON.parse($redis.get @access_token_key).symbolize_keys!
    else
      request_uri   = "/cgi-bin/token?grant_type=client_credential"
      request_args  = {appid: @wechat_config[:app_id], secret: @wechat_config[:secret]}
      response_body = send_request request_uri, request_args
      $redis.set @access_token_key, response_body.to_json, {ex: 60 * 60}
      response_body
    end
  end

  # 通过 OAuth 获取微信的 Access Token
  # 参考文档：https://mp.weixin.qq.com/wiki?t=resource/res_main&id=mp1421140842
  def oauth_access_token(code)
    request_uri  = "/sns/oauth2/access_token?grant_type=authorization_code"
    request_args = {appid: @wechat_config[:app_id], secret: @wechat_config[:secret], code: code}
    send_request request_uri, request_args
  end

  # 获取微信用户的基本信息
  # 参考文档：https://mp.weixin.qq.com/wiki?t=resource/res_main&id=mp1421140842
  def user_info(access_token, open_id)
    request_uri  = "/sns/userinfo?lang=zh_CN"
    request_args = {access_token: access_token, openid: open_id}
    send_request request_uri, request_args
  end

end