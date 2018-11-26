class CreateVachanas < ActiveRecord::Migration
  def change
    create_table :vachanas do |t|
      t.integer :vachanaid
      t.string :name
      t.text :vachana
      t.integer :vachanakaara_id

      t.timestamps
    end
  end
end
