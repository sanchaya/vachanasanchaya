require 'csv'
desc "Import vachana from csv"
task :import_vachana_from_csv => :environment do

  file_name = Rails.root.to_s+"/db/Vachana_db.csv"
  CSV.foreach(file_name, :headers => true) do |row|
    @vachanakaara = Vachanakaara.find_by_name(row['author'])

    unless @vachanakaara
      @vachanakaara = Vachanakaara.create(name: row['author'])
    end

    @vachana = @vachanakaara.vachanas.create(vachana: row['vachana'])
  end

end