class CreateGlossaries < ActiveRecord::Migration
  def change
    create_table :glossaries do |t|
      t.string :word
      t.text :meanings
      t.timestamps
    end
  end
end
