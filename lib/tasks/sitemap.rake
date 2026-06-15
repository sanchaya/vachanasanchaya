# frozen_string_literal: true

require 'builder'

namespace :sitemap do
  desc "Generate sitemap.xml with all database URLs"
  task generate: :environment do
    sitemap_path = Rails.root.join('public', 'sitemap.xml')
    
    xml = Builder::XmlMarkup.new(indent: 2)
    xml.instruct! :xml, version: '1.0', encoding: 'UTF-8'
    xml.urlset(xmlns: 'http://www.sitemaps.org/schemas/sitemap/0.9') do
      
      # Static pages
      add_url(xml, root_url, Date.today, 'daily', '1.0')
      add_url(xml, about_us_url, Date.today, 'monthly', '0.7')
      add_url(xml, contact_us_url, Date.today, 'monthly', '0.7')
      add_url(xml, help_url, Date.today, 'monthly', '0.7')
      add_url(xml, about_us_url(locale: 'en'), Date.today, 'monthly', '0.6')
      
      # Alphabet navigation pages
      all_letters = %w[ಅ ಆ ಇ ಈ ಉ ಊ ಋ ೠ ಎ ಏ ಐ ಒ ಓ ಔ ಅಂ ಅಃ ಕ ಖ ಗ ಘ ಙ ಚ ಛ ಜ ಝ ಞ ಟ ಠ ಡ ಢ ಣ ತ ಥ ದ ಧ ನ ಪ ಫ ಬ ಭ ಮ ಯ ರ ಱ ಲ ವ ಶ ಷ ಸ ಹ ಳ]
      
      all_letters.each do |letter|
        add_url(xml, vachanakaaras_url(start_letter: letter), Date.today, 'weekly', '0.7')
        add_url(xml, vachana_concord_vachanas_url(start_letter: letter), Date.today, 'weekly', '0.7')
        add_url(xml, researches_url(start_letter: letter), Date.today, 'weekly', '0.6')
      end
      
      # Vachanakaara pages
      puts "Adding vachanakaara pages..."
      Vachanakaara.pluck(:id, :updated_at).each do |id, updated_at|
        add_url(xml, vachanakaara_url(id), updated_at || Date.today, 'weekly', '0.8')
      end
      
      # Vachana pages
      puts "Adding vachana pages..."
      Vachana.pluck(:id, :updated_at).each do |id, updated_at|
        add_url(xml, vachana_url(id), updated_at || Date.today, 'monthly', '0.6')
      end
      
      # Glossary pages
      puts "Adding glossary pages..."
      Glossary.pluck(:id).each do |id|
        add_url(xml, glossary_url(id), Date.today, 'monthly', '0.5')
      end
    end
    
    File.write(sitemap_path, xml.target!)
    puts "Sitemap generated successfully at #{sitemap_path}"
    puts "Total URLs: #{xml.target!.scan('<url>').count}"
  end
  
  def add_url(xml, loc, lastmod, changefreq, priority)
    xml.url do
      xml.loc loc
      xml.lastmod lastmod.strftime('%Y-%m-%d')
      xml.changefreq changefreq
      xml.priority priority
    end
  end
end
