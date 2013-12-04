class AddIndexToVachanas < ActiveRecord::Migration
  def change
  	add_index :vachanas, :vachana
  end
end
