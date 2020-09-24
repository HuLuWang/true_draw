class CreateLottery < ActiveRecord::Migration[6.0]
  def change
    create_table :lottery, id: :integer, comment: "抽奖" do |t|
      t.string :image, null: false, comment: "活动主图"
      t.string :title, null: false, comment: "抽奖活动标题"
      t.text :content, null: false, comment: "抽奖活动描述"
      t.string :lottery_type, null: false, default: "simple", comment: "类型 simple, support, wheel"
      t.string :condition, null: false
      t.datetime :lottery_time, comment: "开奖时间"
      t.integer :lottery_num, comment: "开奖人数"
      t.string :state, limit: 32, null: false, default: "start", comment: "start, end"
      t.string :random_index, limit: 128, comment: "硬件真随机数index"
      t.integer :created_by, null: false, comment: "创建人ID", index: true
      t.timestamps
    end
  end
end
