class CreateStaticPages < ActiveRecord::Migration
  def change
    create_table :static_pages do |t|
      t.string :slug
      t.string :title
      t.text :body
      t.string :locale
      t.timestamps
    end
    add_index :static_pages, [:slug, :locale], unique: true
  end
end