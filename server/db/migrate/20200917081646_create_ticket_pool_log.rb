class CreateTicketPoolLog < ActiveRecord::Migration[6.0]
  def change
    create_table :ticket_pool_log, id: :integer, comment: "票池" do |t|
      t.integer :lottery_id, null: false, comment: "活动Id", index: true
      t.integer :user_id, null: false, comment: "用户ID", index: true
      t.integer :help_user_id, comment: "参与助力的用户"
      t.timestamps
    end
  end
end
