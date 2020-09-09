class User < ApplicationRecord
  self.table_name = "member_user"

  has_many :owner_lotteries, class_name: "Lottery", foreign_key: :created_by
  has_many :part_lotteries, class_name: "Lottery", through: :lottery_users


end