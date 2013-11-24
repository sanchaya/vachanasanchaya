require 'csv'
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

  desc "Update new vachanakaara"
task :import_vachana_from_csv => :environment do
	puts "Before start vachanakaara.count is"

	puts Vachanakaara.count
	puts "After deleting table vachanakaara"
Vachanakaara.delete_all
ActiveRecord::Base.connection.execute("DELETE from sqlite_sequence where name = 'vachanakaaras'") 
puts Vachanakaara.count
	puts "started >>>"
i = 1
  file_name = Rails.root.to_s+"/db/test.csv"
  CSV.foreach(file_name, :headers => true) do |row|
puts i 
      @vachanakaara = Vachanakaara.create(name: row['name'])
      i += 1

  end
puts "success"

end



 desc "Update new vachanas"
task :update_vachanas_from_csv => :environment do
	puts "Before start Vachana.count is"

	puts Vachana.count
	puts "After deleting table Vachana"
Vachana.delete_all
ActiveRecord::Base.connection.execute("DELETE from sqlite_sequence where name = 'vachanas'") 
puts Vachana.count
	puts "started >>>"
i = 1
  file_name = Rails.root.to_s+"/db/vachana.csv"
  CSV.foreach(file_name, :headers => true) do |row|
puts i 
      @vachana = Vachana.create(vachanakaara_id: row['vachanakaara_id'], vachana: row['vachana'], vachanaid: row['vachanaid'])
   
      i += 1

  end
puts "success"

end