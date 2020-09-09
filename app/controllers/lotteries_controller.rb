class LotteriesController < ApplicationController
  before_action :lottery_params_check, only: %(create, edit)

  # 创建
  def create
    lottery_id = Lottery.generate(params)
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
    lottery = Lottery.where(id: params[:id], created_by: @member_user.id).first
    lottery.destroy!
    render json: {code: 200, msg: "success", data: {id: params[:id]}}
  end

  # 详情
  # 活动图 标题 状态 开奖时间 发起人 内容 奖品 中奖名单 是否中奖
  def show
    lottery = Lottery.find params[:id]
    is_winner = lottery.award_users.pluck(:member_user_id).include? @member_user.id
    info    = lottery.detail_info.merge!(
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
    render json: {code: 400, msg: "活动非开始状态"} and return unless lottery.start?
    LotteryUser.generate({member_user_id: @member_user.id, lottery_id: params[:id]})
    render json: {code: 200, msg: "success"}
  end

  private

  def lottery_params_check
    # 标题不能为空
    if params[:title].blank?
      render json: {code: ErrCode::ParamCheckFail, msg: "活动标题不能为空"} and return
    end

    # 开始时间需超过当前时间半小时
    if params[:begin_time].to_time < Time.now + 10.minutes
      render json: {code: ErrCode::ParamCheckFail, msg: "活动开始时间不得早于当前时间10分钟"} and return
    end
    # 结束时间不能超过开始时间30天
    if params[:end_time] > params[:begin_time] + 30.days
      render json: {code: ErrCode::ParamCheckFail, msg: "开奖时间不能超过开始时间30天"} and return
    end
    # 奖品不能为空
    if params[:award_list].blank?
      render json: {code: ErrCode::ParamCheckFail, msg: "奖品不能为空"} and return
    end

    # 编辑校验
    if params[:id].present?
      @lottery = Lottery.where(id: params[:id], created_by: @member_user.id).first
      render json: {code: ErrCode::ParamCheckFail, msg: "活动不存在或非本人创建的活动"} and return if @lottery.nil?
      render json: {code: ErrCode::ParamCheckFail, msg: "活动已开始，不允许编辑"} and return unless @lottery.not_start?
    end
  end
end