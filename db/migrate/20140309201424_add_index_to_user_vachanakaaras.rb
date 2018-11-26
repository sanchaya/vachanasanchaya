class AddIndexToUserVachanakaaras < ActiveRecord::Migration
  def change
    add_index :user_vachanakaaras, :user_id
    add_index :user_vachanakaaras, :vachanakaara_id
  end
end
