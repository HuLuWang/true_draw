# 参与者
class LotteryUser < ApplicationRecord
  belongs_to :lottery
  belongs_to :user, foreign_key: :member_user_id

  def self.generate option
    LotteryUser.create!(
                   member_user_id: option[:member_user_id],
                   lottery_id: option[:lottery_id]
    )
  end
end