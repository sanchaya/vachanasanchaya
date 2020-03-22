class AddColumnToVachanas < ActiveRecord::Migration
  def change
  	add_column :vachanas, :meaning, :text
  end
end
