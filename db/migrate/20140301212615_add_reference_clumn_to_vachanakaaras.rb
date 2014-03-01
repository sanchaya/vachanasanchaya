class AddReferenceClumnToVachanakaaras < ActiveRecord::Migration
  def change
    add_column :vachanakaaras, :reference_book_id, :integer
    add_index :vachanakaaras, :reference_book_id
  end

end
