class CreateOldVachanas < ActiveRecord::Migration
  def change
    create_table :old_vachanas do |t|
      t.integer :vachana_id
      t.text :old_vachana 
      t.integer :old_vachanaid 
      t.string :old_name 
      t.integer :reviewer_id 
      t.integer :publisher_id
      t.timestamps
    end
    add_index :old_vachanas, :vachana_id
    add_index :old_vachanas, :reviewer_id
    add_index :old_vachanas, :publisher_id
  end
end
