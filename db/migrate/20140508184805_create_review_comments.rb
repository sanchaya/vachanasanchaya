class CreateReviewComments < ActiveRecord::Migration
  def change
    create_table :review_comments do |t|
      t.integer :review_vachana_id
      t.text :comment
      t.integer :user_id
      t.timestamps
    end
  end
end
