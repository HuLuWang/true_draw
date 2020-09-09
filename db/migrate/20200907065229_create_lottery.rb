class CreateLottery < ActiveRecord::Migration[6.0]
  def change
    create_table :lottery, id: :integer, comment: "抽奖" do |t|
      t.string :image, null: false, comment: "活动主图"
      t.string :title, null: false, comment: "抽奖活动标题"
      t.text :content, null: false, comment: "抽奖活动描述"
      t.string :lottery_type, null: false, default: "common", comment: "类型 common, multi, sz"
      t.datetime :begin_time, null: false, default: -> {"CURRENT_TIMESTAMP"}
      t.datetime :lottery_time, null: false, comment: "开奖时间"
      t.string :state, limit: 32, null: false, comment: "not_start start end"
      t.string :random_index, limit: 128, comment: "硬件真随机数index"
      t.integer :created_by, null: false, comment: "创建人ID"
      t.timestamps
    end
  end
end
