# 参与者
class LotteryUser < ApplicationRecord
  belongs_to :lottery
  belongs_to :user
  after_create :run_lottery

  def self.generate option
     LotteryUser.create!(
        user_id:    option[:user_id],
        lottery_id: option[:lottery_id]
    )
    TicketPoolLog.create!(
        lottery_id: option[:lottery_id],
        user_id:    option[:user_id],
    )
  end

  private
  def run_lottery
    return unless self.lottery.open_by_num?
    part_num = self.lottery.lottery_users.count
    return if part_num < self.lottery.lottery_num
    RunLotteryJob.perform_now(self.lottery_id)
  end
end