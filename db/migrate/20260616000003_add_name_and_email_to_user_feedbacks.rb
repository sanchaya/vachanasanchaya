class AddNameAndEmailToUserFeedbacks < ActiveRecord::Migration
  def up
    add_column :user_feedbacks, :name, :string
    add_column :user_feedbacks, :email, :string
  end

  def down
    remove_column :user_feedbacks, :email
    remove_column :user_feedbacks, :name
  end
end