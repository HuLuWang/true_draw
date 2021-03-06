class UserController < ApplicationController

  def user_oauth
    wx_service = WxService.new
    oauth_resp = wx_service.oauth_access_token(user_auth_args['code'])
    Rails.logger.info "用户openid: #{oauth_resp[:openid]}, 用户access_token: #{oauth_resp[:access_token]}"
    user_info      = wx_service.user_info(oauth_resp[:access_token], oauth_resp[:openid])
    @user          = User.where(open_id: oauth_resp[:openid]).first_or_initialize
    @user.nickname = user_info[:nickname]
    @user.avatar   = user_info[:headimgurl]
    @user.mobile   = user_info[:mobile]
    @user.save!
    Rails.logger.info "====用户数据验证END===="
    render json: {code: 200,
                  msg:  "微信授权验证成功",
                  data: {
                      id:       @user.id,
                      token:    @user.token,
                      nickname: @user.nickname,
                      avatar:   @user.avatar
                  }
    }
  rescue => e
    Rails.logger.error "#{e.class.name}: #{e.message}"
    render json: {code: 500, msg: "微信授权验证失败"}
  end
end