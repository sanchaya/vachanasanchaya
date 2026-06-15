class AddIndexToVachanasVachana < ActiveRecord::Migration
  def up
    add_index :vachanas, :vachana, length: 255
  end

  def down
    remove_index :vachanas, :vachana
  end
end
