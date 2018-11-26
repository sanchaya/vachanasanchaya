class IndexingToManyTables < ActiveRecord::Migration
  def change
    #vachanas
    add_index :vachanas, :vachanaid
    add_index :vachanas, :vachanakaara_id
#vachanakaaras
    add_index :vachanakaaras, :name
    add_index :vachanakaaras, :ankitha_naama
#concords
    add_index :concords, :parent_id
    add_index :concords, :count
#daily vachana
    add_index :daily_vachanas, :vachana_id
  end

end
