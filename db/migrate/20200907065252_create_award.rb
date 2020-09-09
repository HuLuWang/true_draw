class CreateAward < ActiveRecord::Migration[6.0]
  def change
    create_table :award, id: :integer, comment: "奖品" do |t|
      t.integer :lottery_id, null: false, comment: "抽奖活动ID"
      t.string :name, null: false, comment: "奖品名称"
      t.string :image, null: false, comment: "奖品主图"
      t.integer :number, null: false, default: 1, comment: "奖品数量"
      t.integer :level, null: false, default: 5, comment: "奖品等级 0 1 2 3 4 5"
      t.timestamps
    end
  end
end
