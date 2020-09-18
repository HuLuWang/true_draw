class CronRunLotteryJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info "福利活动定时开奖Start #{Time.now}"
    now       = Time.now
    lotteries = Lottery.where(state: "start", condition: "time", lottery_time: [(now - 1.minutes)..now])
    return if lotteries.blank?
    lotteries.each do |l|
      RunLotteryJob.perform_later l.id
    end
    Rails.logger.info "福利活动开奖END #{Time.now}"
  end

end
