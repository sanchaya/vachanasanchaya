class AdColumnsToVachanakaaras < ActiveRecord::Migration
  def change
    add_column :vachanakaaras, :time_period, :string
    add_column :vachanakaaras, :vachana_found, :integer
    add_column :vachanakaaras, :sex, :boolean
    add_column :vachanakaaras, :information, :text
    add_column :vachanakaaras, :parents, :string
    add_column :vachanakaaras, :spouse, :string
  end

end
