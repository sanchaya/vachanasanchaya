class AddReviewedColumnToVachanas < ActiveRecord::Migration
  def change
    add_column :vachanas, :reviewed, :boolean, default: false
  end
end
