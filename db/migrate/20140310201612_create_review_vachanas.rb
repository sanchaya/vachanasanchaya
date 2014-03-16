class CreateReviewVachanas < ActiveRecord::Migration
  def change
    create_table :review_vachanas do |t|
       t.integer :vachana_id  #which vachana for review
       t.integer :reviewer_id # user who reviwed
       t.boolean :published # reviewed vachana published
       t.integer :publisher_id  # user who published reviwed vachana
       t.text :review_vachana # reviewed vachana
       t.integer :review_vachanaid  # reviewed vachanaid (samputa number)
       t.string :review_name #reviewed vachana name 
       t.boolean :reviewed #whether its rewieved and ready for publish ?
       t.timestamps
     end
     add_index :review_vachanas, :vachana_id
     add_index :review_vachanas, :reviewer_id
     add_index :review_vachanas, :publisher_id
   end
 end
