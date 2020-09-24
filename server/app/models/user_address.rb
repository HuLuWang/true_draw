class UserAddress < ApplicationRecord
  belongs_to :user
  before_create :change_default_address

  private
  # 保证只有一个默认地址
  def change_default_address
    old_address = UserAddress.where(user_id: self.user_id, state: 1).first
    old_address.update!(state: 0) if old_address.present?
  end
end