class AddPerformanceIndexes < ActiveRecord::Migration
  def up
    add_column :vachanas, :vachana_first_letter, :string, limit: 1
    add_index :vachanas, :vachana_first_letter, name: "index_vachanas_on_vachana_first_letter"

    execute <<-SQL
      UPDATE vachanas
      SET vachana_first_letter = LEFT(TRIM(vachana), 1)
      WHERE vachana IS NOT NULL AND vachana != ''
    SQL

    execute "CREATE FULLTEXT INDEX index_vachanas_on_vachana_fulltext ON vachanas (vachana)"
  end

  def down
    execute "DROP INDEX index_vachanas_on_vachana_fulltext ON vachanas"
    remove_index :vachanas, name: "index_vachanas_on_vachana_first_letter"
    remove_column :vachanas, :vachana_first_letter
  end
end
