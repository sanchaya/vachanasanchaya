class CreateUserVachanakaaras < ActiveRecord::Migration
  def change
    create_table :user_vachanakaaras do |t|
      t.integer :vachanakaara_id
      t.integer :user_id
      t.timestamps
    end
  end
end
