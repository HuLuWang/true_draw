# 中奖者
class AwardUser < ApplicationRecord
  belongs_to :user, foreign_key: :user_id
  belongs_to :award
end