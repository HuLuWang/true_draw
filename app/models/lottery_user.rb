# 参与者
class LotteryUser < ApplicationRecord
  belongs_to :lottery
  belongs_to :user

  def self.generate option
    lottery = LotteryUser.create!(
                   user_id: option[:user_id],
                   lottery_id: option[:lottery_id]
    )
    $redis.rpush("USER_POOL:#{lottery.id}", option[:user_id])
  end
end