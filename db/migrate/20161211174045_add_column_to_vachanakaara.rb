class AddColumnToVachanakaara < ActiveRecord::Migration
  def change
    add_column :vachanakaaras, :slug_name, :string, unique: true
    add_column :vachanakaaras, :slug, :string
    add_index :vachanakaaras, :slug, unique: true
  end
end
