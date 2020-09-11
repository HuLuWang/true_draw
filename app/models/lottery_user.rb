# 参与者
class LotteryUser < ApplicationRecord
  belongs_to :lottery
  belongs_to :user

  def self.generate option
    LotteryUser.create!(
                   user_id: option[:user_id],
                   lottery_id: option[:lottery_id]
    )
  end
end