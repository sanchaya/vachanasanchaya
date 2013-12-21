class ChangeColumnsKeyWord < ActiveRecord::Migration
  def up
  	remove_column :key_words, :vachana_id
  	add_column :key_words, :vachana_ids, :text
  end

  def down
  	add_column :key_words, :vachana_id, :integer
  	remove_column :key_words, :vachana_ids
  end
end
