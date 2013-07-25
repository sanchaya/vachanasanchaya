class CreateWordLists < ActiveRecord::Migration
  def change
    create_table :word_lists do |t|
t.string :name
      t.timestamps
    end
  end
end
