class User < ApplicationRecord

  has_many :owner_lotteries, class_name: "Lottery", foreign_key: :created_by
  has_many :lottery_users
  has_many :lotteries, through: :lottery_users
  has_many :user_addresses

  def token
    TokenService.encode({userId: self.id, source: 'true_draw'})
  end

  def default_address
    self.user_addresses.where(state: 1).first
  end

end