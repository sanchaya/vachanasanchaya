class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :glossaries, :word, name: "index_glossaries_on_word"
    add_index :word_lists, :name, name: "index_word_lists_on_name"
    add_index :roles, :name, name: "index_roles_on_name"
    add_index :review_comments, :review_vachana_id, name: "index_review_comments_on_review_vachana_id"
    add_index :review_comments, :user_id, name: "index_review_comments_on_user_id"
    add_index :daily_vachanas, :created_at, name: "index_daily_vachanas_on_created_at"
  end
end
