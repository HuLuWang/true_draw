class CreateUserAddress < ActiveRecord::Migration[6.0]
  def change
    create_table :user_address, id: :integer, comment: "用户地址" do |t|
      t.integer :user_id, null: false, comment: "用户ID"
      t.string  :mobile, null: false, comment: "收货人手机号"
      t.string  :address, null: false, comment: "地址"
      t.integer :state, null: false, default: 1, comment: "状态 1 默认地址 0 非默认地址"
      t.timestamps
    end
  end
end
