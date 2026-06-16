class CreateJoinTables < ActiveRecord::Migration
  def up
    create_table :keyword_vachanas do |t|
      t.integer :key_word_id, null: false
      t.integer :vachana_id,  null: false
      t.integer :count,       null: false, default: 0
    end
    add_index :keyword_vachanas, [:key_word_id, :vachana_id], unique: true, name: "index_kw_vachanas_on_keyword_and_vachana"
    add_index :keyword_vachanas, :vachana_id, name: "index_kw_vachanas_on_vachana_id"

    create_table :keyword_vachanakaaras do |t|
      t.integer :key_word_id,      null: false
      t.integer :vachanakaara_id,  null: false
    end
    add_index :keyword_vachanakaaras, [:key_word_id, :vachanakaara_id], unique: true, name: "index_kw_vas_on_keyword_and_vachanakaara"
    add_index :keyword_vachanakaaras, :vachanakaara_id, name: "index_kw_vas_on_vachanakaara_id"

    create_table :concord_items do |t|
      t.integer :concord_id, null: false
      t.integer :item_id,    null: false
    end
    add_index :concord_items, [:concord_id, :item_id], unique: true, name: "index_concord_items_on_concord_and_item"
    add_index :concord_items, :item_id, name: "index_concord_items_on_item_id"
  end

  def down
    drop_table :keyword_vachanas
    drop_table :keyword_vachanakaaras
    drop_table :concord_items
  end
end
