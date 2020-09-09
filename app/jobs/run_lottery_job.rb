class RunLotteryJob < ApplicationJob
  queue_as :default

  def perform lottery_id
    Rails.logger.info "福利活动开奖Start #{Time.now}"
    service = LotteryService.new lottery_id
    service.offer_award
    Rails.logger.info "福利活动开奖END #{Time.now}"
  end

end
