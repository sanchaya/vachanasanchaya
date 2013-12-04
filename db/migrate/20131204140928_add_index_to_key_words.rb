class AddIndexToKeyWords < ActiveRecord::Migration
  def change
  	add_index :key_words, :word
  end
end
