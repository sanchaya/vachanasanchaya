class AddColumnToVachanakaaras < ActiveRecord::Migration
  def change
    add_column :vachanakaaras, :ankitha_naama, :string
  end
end
