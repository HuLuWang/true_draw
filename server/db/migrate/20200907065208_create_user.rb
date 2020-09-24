class CreateUser < ActiveRecord::Migration[6.0]
  def change
    create_table :user, id: :integer, comment: "用户" do |t|
      t.string :nickname, limit: 32, null: false, default: "游客", comment: "昵称"
      t.string :avatar, comment: "头像"
      t.string :mobile, limit: 11, comment: "手机号"
      t.string :union_id, comment: "微信union_id"
      t.timestamps
    end
  end
end
