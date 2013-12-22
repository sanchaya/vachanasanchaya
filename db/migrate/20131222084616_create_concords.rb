class CreateConcords < ActiveRecord::Migration
  def change
    create_table :concords do |t|
t.string :name
t.integer :parent_id
t.string :concord_code
t.integer :count
t.text :vachanakaara_ids
      t.timestamps
    end
  end
end
