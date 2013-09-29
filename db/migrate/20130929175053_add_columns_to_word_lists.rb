class AddColumnsToWordLists < ActiveRecord::Migration
  def change
    add_column :word_lists, :exact_search_count, :integer, default: 0
    add_column :word_lists, :like_search_count, :integer, default: 0
  end
end
