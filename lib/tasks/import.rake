require 'csv'


desc "Import Glosary from csv"
task :import_glossary_from_csv => :environment do
  file_name = Rails.root.to_s+"/lib/tasks/meanings_vachana.csv"
  puts "started"
  CSV.foreach(file_name, :col_sep => ":",:headers=> false) do |row|
    Glossary.create(word: row[0], meanings: row[1])
    puts row[0]
    puts ">>>>>>>>>>>>>.."
  end
  puts "End "
end


desc "Update reviewed column in vachanas"

task :update_review_column_in_vachanas => :environment do
  reviewed_vachanas = ReviewVachana.where(published: true)
  reviewed_vachanas.each do |rv|
    rv.vachana.update_attribute('reviewed',true)
  end
end


# desc "Import vachana from csv"
# task :import_vachana_from_csv => :environment do

#   file_name = Rails.root.to_s+"/db/Vachana_db.csv"
#   CSV.foreach(file_name, :headers => true) do |row|
#     @vachanakaara = Vachanakaara.find_by_name(row['author'])

#     unless @vachanakaara
#       @vachanakaara = Vachanakaara.create(name: row['author'])
#     end

#     @vachana = @vachanakaara.vachanas.create(vachana: row['vachana'])
#   end

# desc "Update new vachanakaara"
# task :import_vachana_from_csv => :environment do
# 	puts "Before start vachanakaara.count is"

# 	puts Vachanakaara.count
# 	puts "After deleting table vachanakaara"
#   Vachanakaara.delete_all
#   ActiveRecord::Base.connection.execute("DELETE from sqlite_sequence where name = 'vachanakaaras'") 
#   puts Vachanakaara.count
#   puts "started >>>"
#   i = 1
#   file_name = Rails.root.to_s+"/db/test.csv"
#   CSV.foreach(file_name, :headers => true) do |row|
#     puts i 
#     @vachanakaara = Vachanakaara.create(name: row['name'])
#     i += 1

#   end
#   puts "success"

# end



# desc "Update new vachanas"
# task :update_vachanas_from_csv => :environment do
# 	puts "Before start Vachana.count is"

# 	puts Vachana.count
# 	puts "After deleting table Vachana"
#   Vachana.delete_all
#   ActiveRecord::Base.connection.execute("DELETE from sqlite_sequence where name = 'vachanas'") 
#   puts Vachana.count
#   puts "started >>>"
#   i = 1
#   file_name = Rails.root.to_s+"/db/vachana.csv"
#   CSV.foreach(file_name, :headers => true) do |row|
#     puts i 
#     @vachana = Vachana.create(vachanakaara_id: row['vachanakaara_id'], vachana: row['vachana'], vachanaid: row['vachanaid'])

#     i += 1

#   end
#   puts "success"

# end


desc "Download keywords with vachanakaaras"
task :download_keywords_with_vachanakaara => :environment do
  KeyWord.vachanakaara_keyword
end


desc "Migrate serialized key_words.vachana_ids and vachanakaara_ids to join tables"
task :migrate_keyword_join_tables => :environment do
  puts "Migrating key_words.vachana_ids (Hash) -> keyword_vachanas table..."
  total = KeyWord.count
  KeyWord.find_each.with_index do |kw, idx|
    puts "  #{idx+1}/#{total} (id=#{kw.id})" if (idx % 1000) == 0
    next if kw.keyword_vachanas.exists? || kw.vachana_ids.blank?
    inserts = []
    kw.vachana_ids.each { |v_id, c| inserts << "(#{kw.id}, #{v_id.to_i}, #{c.to_i})" }
    ActiveRecord::Base.connection.execute(
      "INSERT INTO keyword_vachanas (key_word_id, vachana_id, count) VALUES #{inserts.join(', ')}"
    ) unless inserts.empty?
  end

  puts "Migrating key_words.vachanakaara_ids (Array) -> keyword_vachanakaaras table..."
  KeyWord.find_each.with_index do |kw, idx|
    puts "  #{idx+1}/#{total} (id=#{kw.id})" if (idx % 1000) == 0
    next if kw.keyword_vachanakaaras.exists? || kw.vachanakaara_ids.blank?
    inserts = kw.vachanakaara_ids.uniq.map { |va_id| "(#{kw.id}, #{va_id})" }
    ActiveRecord::Base.connection.execute(
      "INSERT INTO keyword_vachanakaaras (key_word_id, vachanakaara_id) VALUES #{inserts.join(', ')}"
    ) unless inserts.empty?
  end

  puts "Done! #{KeywordVachana.count} keyword_vachana rows, #{KeywordVachanakaara.count} keyword_vachanakaara rows created."
end


desc "Migrate serialized concords.ids to concord_items table"
task :migrate_concord_join_table => :environment do
  puts "Migrating concords.ids (Array) -> concord_items table..."
  total = Concord.count
  Concord.find_each.with_index do |c, idx|
    puts "  #{idx+1}/#{total} (id=#{c.id})" if (idx % 100) == 0
    next if c.concord_items.exists? || c.ids.blank?
    ids = c.ids.is_a?(Array) ? c.ids : [c.ids]
    inserts = ids.map { |item_id| "(#{c.id}, #{item_id.to_i})" }
    ActiveRecord::Base.connection.execute(
      "INSERT INTO concord_items (concord_id, item_id) VALUES #{inserts.join(', ')}"
    ) unless inserts.empty?
  end
  puts "Done! #{ConcordItem.count} concord_items rows created."
end


desc "Run all serialized column data migrations"
task :migrate_all_serialized_data => [:migrate_keyword_join_tables, :migrate_concord_join_table] do
  puts "All serialized data migrated. Old columns (vachana_ids, vachanakaara_ids, ids) can now be dropped."
end