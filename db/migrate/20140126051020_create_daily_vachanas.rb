class CreateDailyVachanas < ActiveRecord::Migration
  def change
    create_table :daily_vachanas do |t|
      t.references :vachana
      

      t.timestamps
    end
  end
end
