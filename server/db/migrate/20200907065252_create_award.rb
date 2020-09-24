class CreateAward < ActiveRecord::Migration[6.0]
  def change
    create_table :award, id: :integer, comment: "奖品" do |t|
      t.integer :lottery_id, null: false, comment: "抽奖活动ID", index: true
      t.string :name, null: false, comment: "奖品名称"
      t.string :image, null: false, comment: "奖品主图"
      t.integer :number, null: false, default: 1, comment: "奖品数量"
      t.timestamps
    end
  end
end
