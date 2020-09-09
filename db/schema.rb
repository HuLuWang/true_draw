# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_07_065308) do

  create_table "award", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "奖品", force: :cascade do |t|
    t.integer "lottery_id", null: false, comment: "抽奖活动ID"
    t.string "name", null: false, comment: "奖品名称"
    t.string "image", null: false, comment: "奖品主图"
    t.integer "number", default: 1, null: false, comment: "奖品数量"
    t.integer "level", default: 5, null: false, comment: "奖品等级 0 1 2 3 4 5"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "award_user", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "获奖名单", force: :cascade do |t|
    t.integer "lottery_id", null: false, comment: "抽奖ID"
    t.integer "member_user_id", null: false, comment: "用户ID"
    t.integer "award_id", null: false, comment: "奖品ID"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["award_id"], name: "index_award_user_on_award_id"
    t.index ["lottery_id"], name: "index_award_user_on_lottery_id"
    t.index ["member_user_id"], name: "index_award_user_on_member_user_id"
  end

  create_table "lottery", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "抽奖", force: :cascade do |t|
    t.string "image", null: false, comment: "活动主图"
    t.string "title", null: false, comment: "抽奖活动标题"
    t.text "content", null: false, comment: "抽奖活动描述"
    t.string "lottery_type", default: "common", null: false, comment: "类型 common, multi, sz"
    t.datetime "begin_time", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "lottery_time", null: false, comment: "开奖时间"
    t.string "state", limit: 32, null: false, comment: "not_start start end"
    t.string "random_index", limit: 128, comment: "硬件真随机数index"
    t.integer "created_by", null: false, comment: "创建人ID"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "lottery_user", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "抽奖参与者", force: :cascade do |t|
    t.integer "lottery_id", null: false, comment: "抽奖ID"
    t.integer "user_id", null: false, comment: "用户ID"
    t.integer "votes", default: 1, null: false, comment: "权重"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["lottery_id"], name: "index_lottery_user_on_lottery_id"
    t.index ["user_id"], name: "index_lottery_user_on_user_id"
  end

  create_table "member_user", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "用户", force: :cascade do |t|
    t.string "nickname", limit: 32, default: "游客", null: false, comment: "昵称"
    t.string "avatar", comment: "头像"
    t.string "mobile", limit: 11, comment: "手机号"
    t.string "union_id", comment: "微信union_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
