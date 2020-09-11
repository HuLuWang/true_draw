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

ActiveRecord::Schema.define(version: 2020_09_11_065621) do

  create_table "award", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "奖品", force: :cascade do |t|
    t.integer "lottery_id", null: false, comment: "抽奖活动ID"
    t.string "name", null: false, comment: "奖品名称"
    t.string "image", null: false, comment: "奖品主图"
    t.integer "number", default: 1, null: false, comment: "奖品数量"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["lottery_id"], name: "index_award_on_lottery_id"
  end

  create_table "award_user", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "获奖名单", force: :cascade do |t|
    t.integer "lottery_id", null: false, comment: "抽奖ID"
    t.integer "user_id", null: false, comment: "用户ID"
    t.integer "award_id", null: false, comment: "奖品ID"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["award_id"], name: "index_award_user_on_award_id"
    t.index ["lottery_id"], name: "index_award_user_on_lottery_id"
    t.index ["user_id"], name: "index_award_user_on_user_id"
  end

  create_table "lottery", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "抽奖", force: :cascade do |t|
    t.string "image", null: false, comment: "活动主图"
    t.string "title", null: false, comment: "抽奖活动标题"
    t.text "content", null: false, comment: "抽奖活动描述"
    t.string "lottery_type", default: "simple", null: false, comment: "类型 simple, support, wheel"
    t.string "condition", null: false
    t.datetime "lottery_time", comment: "开奖时间"
    t.integer "lottery_num", comment: "开奖人数"
    t.string "state", limit: 32, default: "start", null: false, comment: "start, end"
    t.string "random_index", limit: 128, comment: "硬件真随机数index"
    t.integer "created_by", null: false, comment: "创建人ID"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_by"], name: "index_lottery_on_created_by"
  end

  create_table "lottery_user", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "抽奖参与者", force: :cascade do |t|
    t.integer "lottery_id", null: false, comment: "抽奖ID"
    t.integer "user_id", null: false, comment: "用户ID"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["lottery_id"], name: "index_lottery_user_on_lottery_id"
    t.index ["user_id"], name: "index_lottery_user_on_user_id"
  end

  create_table "user", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "用户", force: :cascade do |t|
    t.string "nickname", limit: 32, default: "游客", null: false, comment: "昵称"
    t.string "avatar", comment: "头像"
    t.string "mobile", limit: 11, comment: "手机号"
    t.string "union_id", comment: "微信union_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_address", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "用户地址", force: :cascade do |t|
    t.integer "user_id", null: false, comment: "用户ID"
    t.string "mobile", null: false, comment: "收货人手机号"
    t.string "address", null: false, comment: "地址"
    t.integer "state", default: 1, null: false, comment: "状态 1 默认地址 0 非默认地址"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
