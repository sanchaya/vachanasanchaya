class CreateUserFeedbacks < ActiveRecord::Migration
  def up
    create_table :user_feedbacks do |t|
      t.integer  :feedbackable_id
      t.string   :feedbackable_type
      t.integer  :user_id
      t.text     :comment,         null: false
      t.string   :status,          default: 'pending'
      t.string   :ip_address
      t.string   :user_agent
      t.datetime :created_at,      null: false
      t.datetime :updated_at,      null: false
    end

    add_index :user_feedbacks, [:feedbackable_id, :feedbackable_type], name: 'idx_user_feedbacks_on_feedbackable'
    add_index :user_feedbacks, :user_id
    add_index :user_feedbacks, :status
  end

  def down
    drop_table :user_feedbacks
  end
end
