class CreateVachanakaaras < ActiveRecord::Migration
  def change
    create_table :vachanakaaras do |t|
      t.string :name
      

      t.timestamps
    end
  end
end
