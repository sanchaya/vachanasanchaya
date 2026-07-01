namespace :site do
  desc "Regenerate cached site statistics (poets, vachanas, keywords counts)"
  task stats: :environment do
    require 'json'
    stats = {
      male_poets:      Vachanakaara.where(sex: true).count,
      female_poets:    Vachanakaara.where(sex: false).count,
      total_poets:     Vachanakaara.count,
      total_vachanas:  Vachana.count,
      total_keywords:  KeyWord.count
    }
    path = Rails.root.join("tmp/site_stats.json")
    File.write(path, stats.to_json)
    puts "Site stats written to #{path}:"
    puts JSON.pretty_generate(stats)
  end
end
