class UserController < ApplicationController

  def user_oauth
    wx_service = WxService.new
    oauth_resp = wx_service.oauth_access_token(user_auth_args['code'])
    Rails.logger.info "用户openid: #{oauth_resp[:openid]}, 用户access_token: #{oauth_resp[:access_token]}"
    user_info             = wx_service.user_info(oauth_resp[:access_token], oauth_resp[:openid])
    @member_user          = User.where(open_id: oauth_resp[:openid]).first_or_initialize
    @member_user.nickname = user_info[:nickname]
    @member_user.avatar   = user_info[:headimgurl]
    @member_user.mobile   = user_info[:mobile]
    @member_user.save!
    Rails.logger.info "====用户数据验证END===="
    render json: {code: 200,
                  msg:  "微信授权验证成功",
                  data: {
                      id:       @member_user.id,
                      token:    @member_user.token,
                      nickname: @member_user.nickname,
                      avatar:   @member_user.avatar
                  }
    }
  rescue => e
    Rails.logger.error "#{e.class.name}: #{e.message}"
    render json: {code: 500, msg: "微信授权验证失败"}
  end

  # 我参与的列表
  def part_list
    list = @member_user.part_lotteries.map do |l|
      {
          id:    l.id,
          title: l.title
      }
    end
    render json: {code: 200, msg: "success", data: {list: list}}
  end

  # 我创建的列表
  def owner_list
    list = @member_user.owner_lotteries.map do |l|
      {
          id:    l.id,
          title: l.title,
          state: l.state
      }
    end
    render json: {code: 200, msg: "success", data: {list: list}}
  end


end