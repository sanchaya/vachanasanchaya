class CreateReferenceBooks < ActiveRecord::Migration
  def change
    create_table :reference_books do |t|
      t.string :book_name
      t.string :book_volume
      t.string :publisher
      t.string :author
      t.string :published_year
      t.string :isbn
      t.string :language
      t.string :reference_type
      t.timestamps
    end
  end
end
