class CreateKeyWords < ActiveRecord::Migration
  def change
    create_table :key_words do |t|
      t.integer :vachana_id
      t.string :word
      t.integer :count
      t.timestamps
    end
  end
end
