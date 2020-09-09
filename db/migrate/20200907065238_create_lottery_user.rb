class CreateLotteryUser < ActiveRecord::Migration[6.0]
  def change
    create_table :lottery_user, id: :integer, comment: "抽奖参与者" do |t|
      t.integer :lottery_id, null: false, comment: "抽奖ID", index: true
      t.integer :user_id, null: false, comment: "用户ID", index: true
      t.integer :votes, null: false, default: 1, comment: "权重"
      t.timestamps
    end
  end
end
