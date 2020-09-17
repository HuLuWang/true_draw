class LotteriesController < ApplicationController
  skip_before_action :authenticate!, only: %w(index )
  before_action :lottery_params_check, only: %w(create edit)

  # 列表
  def index
    page      = params[:page] || 1
    page_size = params[:page_size] || 10
    lotteries = Lottery.all.order(id: :desc)
    if params[:state] == "start"
      result    = lotteries.where(state: "start").page(page).per(page_size)
    else
      result    = lotteries.where(state: "end").page(page).per(page_size)
    end
    list      = result.map do |l|
      l.detail_info
    end
    render json: {code: 200, msg: "success", data: {
        list:      list,
        page:      page,
        page_size: page_size,
        total:     result.total_count
    }}
  end

  # 创建
  def create
    option     = params.merge!({user_id: @user.id})
    lottery_id = Lottery.generate(option)
    render json: {code: 400, msg: "新建抽奖活动失败"} and return if lottery_id.nil?
    render json: {code: 200, msg: "success", data: {id: lottery_id}}
  end

  # 编辑
  def edit
    @lottery.edit(params)
    render json: {code: 200, msg: "success", data: {id: @lottery.id}}
  end

  # 删除
  # 真删除
  def delete
    lottery = Lottery.where(id: params[:id], created_by: @user.id).first
    lottery.destroy!
    render json: {code: 200, msg: "success", data: {id: params[:id]}}
  end

  # 详情
  # 活动图 标题 状态 开奖时间 发起人 内容 奖品 中奖名单 是否中奖
  def show
    lottery   = Lottery.find params[:id]
    is_winner = lottery.award_users.pluck(:user_id).include? @user.id
    info      = lottery.detail_info.merge!(
        {
            is_winner: is_winner
        }
    )
    render json: {code: 200, msg: "success", data: {info: info}}
  end

  # 参与
  # 不同活动有不同的参与规则
  def part_in
    lottery = Lottery.find params[:id]
    render json: {code: ErrCode::ActivityNotStart, msg: "活动非开始状态"} and return unless lottery.start?
    LotteryUser.generate({user_id: @user.id, lottery_id: lottery.id})
    render json: {code: 200, msg: "success"}
  end

  # 我参与的列表
  def part_list
    list = @user.part_lotteries.map do |l|
      {
          id:    l.id,
          title: l.title
      }
    end
    render json: {code: 200, msg: "success", data: {list: list}}
  end

  # 我创建的列表
  def my_list
    list = @user.owner_lotteries.map do |l|
      {
          id:    l.id,
          title: l.title,
          state: l.state
      }
    end
    render json: {code: 200, msg: "success", data: {list: list}}
  end

  # 参与助力
  # 用户要先授权
  def help_friend
    lottery_user = LotteryUser.where(lottery_id: params[:lottery_id],user_id: params[:user_id]).first
    render json: {code: ErrCode::UserNotPart, msg: "邀请者未参与活动"} and return if lottery_user.nil?
    log = TicketPoolLog.where(lottery_id: params[:lottery_id], user_id: params[:user_id], help_user_id: @user.id).first
    render json: {code: ErrCode::ALREADYHELP, msg: "已帮此好友助力过了，自己也快来参与吧"} and return if log.present?
    @user.help_friend({user_id: params[:user_id], lottery_id: params[:lottery_id]})
    render json: {code: 200, msg: "success"}
  end

  private

  def lottery_params_check
    # 标题不能为空
    if params[:title].blank?
      render json: {code: ErrCode::ParamCheckFail, msg: "活动标题不能为空"} and return
    end

    # 奖品不能为空
    if params[:award_list].blank?
      render json: {code: ErrCode::ParamCheckFail, msg: "奖品不能为空"} and return
    end

    if params[:condition].blank?
      render json: {code: ErrCode::ParamCheckFail, msg: "活动开奖类型不能为空"} and return
    end

    # 按时开奖校验
    if params[:condition] == "time"
      # 结束时间不能超过当前时间30天
      if params[:lottery_time] > Time.now + 30.days
        render json: {code: ErrCode::ParamCheckFail, msg: "开奖时间不能超过开始时间30天"} and return
      end
    end

    # 按人数开奖校验
    if params[:condition] == "num"
      # 参与人数不能小于1
      if params[:lottery_num] < 1
        render json: {code: ErrCode::ParamCheckFail, msg: "参与人数不能小于1"} and return
      end
    end

    # 编辑校验
    if params[:id].present?
      @lottery = Lottery.where(id: params[:id], created_by: @user.id).first
      render json: {code: ErrCode::ParamCheckFail, msg: "活动不存在或非本人创建的活动"} and return if @lottery.nil?
      render json: {code: ErrCode::ParamCheckFail, msg: "活动已结束，不允许编辑"} and return unless @lottery.start?
    end
  end
end