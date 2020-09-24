class CreateAwardUser < ActiveRecord::Migration[6.0]
  def change
    create_table :award_user, id: :integer, comment: "获奖名单" do |t|
      t.integer :lottery_id, null: false, comment: "抽奖ID", index: true
      t.integer :user_id, null: false, comment: "用户ID", index: true
      t.integer :award_id, null: false, comment: "奖品ID", index: true
      t.timestamps
    end
  end
end
