#!/usr/bin/env ruby
# Standalone sitemap generator - creates multiple sitemap files and an index

require 'mysql2'
require 'date'
require 'uri'
require 'stringio'

DB_CONFIG = {
  host: 'localhost',
  username: 'vachana_concord',
  password: ENV['DB_PASSWORD'] || raise("Set DB_PASSWORD environment variable"),
  database: 'vachana_concord',
  encoding: 'utf8'
}

SITE_URL = "https://vachana.sanchaya.net"
TODAY = Date.today.strftime('%Y-%m-%d')

# All Kannada letters for alphabet navigation
ALL_LETTERS = %w[
  ಅ ಆ ಇ ಈ ಉ ಊ ಋ ೠ ಎ ಏ ಐ ಒ ಓ ಔ ಅಂ ಅಃ
  ಕ ಖ ಗ ಘ ಙ ಚ ಛ ಜ ಝ ಞ ಟ ಠ ಡ ಢ ಣ ತ ಥ ದ ಧ ನ
  ಪ ಫ ಬ ಭ ಮ ಯ ರ ಱ ಲ ವ ಶ ಷ ಸ ಹ ಳ
]

def generate_sitemap_batches(urls, batch_size = 50000)
  batches = []
  urls.each_slice(batch_size).each_with_index do |batch, index|
    batches << { index: index, urls: batch }
  end
  batches
end

def generate_xml(urls)
  xml = StringIO.new
  xml << %(<?xml version="1.0" encoding="UTF-8"?>\n)
  xml << %(<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n)
  
  urls.each do |url|
    xml << %(  <url>\n)
    xml << %(    <loc>#{url[:loc]}</loc>\n)
    xml << %(    <lastmod>#{url[:lastmod]}</lastmod>\n)
    xml << %(    <changefreq>#{url[:changefreq]}</changefreq>\n)
    xml << %(    <priority>#{url[:priority]}</priority>\n)
    xml << %(  </url>\n)
  end
  
  xml << %(</urlset>\n)
  xml.string
end

def generate_sitemap_index(batches)
  xml = StringIO.new
  xml << %(<?xml version="1.0" encoding="UTF-8"?>\n)
  xml << %(<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n)
  
  batches.each do |batch|
    sitemap_file = "sitemap#{batch[:index]}.xml"
    xml << %(  <sitemap>\n)
    xml << %(    <loc>#{SITE_URL}/#{sitemap_file}</loc>\n)
    xml << %(    <lastmod>#{TODAY}</lastmod>\n)
    xml << %(  </sitemap>\n)
  end
  
  xml << %(</sitemapindex>\n)
  xml.string
end

client = Mysql2::Client.new(DB_CONFIG)

# Build all URLs (same logic as before)
urls = []

# Static pages
add_url = lambda do |loc, lastmod, changefreq, priority|
  urls << { loc: loc, lastmod: lastmod, changefreq: changefreq, priority: priority }
end

add_url.call("#{SITE_URL}/", TODAY, 'daily', '1.0')
add_url.call("#{SITE_URL}/about_us", TODAY, 'monthly', '0.7')
add_url.call("#{SITE_URL}/contact_us", TODAY, 'monthly', '0.7')
add_url.call("#{SITE_URL}/help", TODAY, 'monthly', '0.7')
add_url.call("#{SITE_URL}/about_us?locale=en", TODAY, 'monthly', '0.6')

# List pages
add_url.call("#{SITE_URL}/vachanakaaras", TODAY, 'weekly', '0.9')
add_url.call("#{SITE_URL}/vachanas/vachana_concord", TODAY, 'weekly', '0.9')
add_url.call("#{SITE_URL}/researches", TODAY, 'weekly', '0.8')
add_url.call("#{SITE_URL}/glossaries", TODAY, 'weekly', '0.8')
add_url.call("#{SITE_URL}/books", TODAY, 'weekly', '0.7')
add_url.call("#{SITE_URL}/vachanas/ai_search", TODAY, 'weekly', '0.6')

# Alphabet navigation pages
ALL_LETTERS.each do |letter|
  encoded = URI.encode_www_form_component(letter)
  add_url.call("#{SITE_URL}/vachanakaaras?start_letter=#{encoded}", TODAY, 'weekly', '0.7')
  add_url.call("#{SITE_URL}/vachanas/vachana_concord?start_letter=#{encoded}", TODAY, 'weekly', '0.7')
  add_url.call("#{SITE_URL}/researches?start_letter=#{encoded}", TODAY, 'weekly', '0.6')
end

# Vachanakaara pages
client.query("SELECT id, updated_at FROM vachanakaaras").each do |row|
  lastmod = row['updated_at'] ? row['updated_at'].strftime('%Y-%m-%d') : TODAY
  add_url.call("#{SITE_URL}/vachanakaaras/#{row['id']}", lastmod, 'weekly', '0.8')
end

# Vachana pages
client.query("SELECT id, updated_at FROM vachanas").each do |row|
  lastmod = row['updated_at'] ? row['updated_at'].strftime('%Y-%m-%d') : TODAY
  add_url.call("#{SITE_URL}/vachanas/#{row['id']}", lastmod, 'monthly', '0.6')
end

# Glossary pages
client.query("SELECT id FROM glossaries").each do |row|
  add_url.call("#{SITE_URL}/glossaries/#{row['id']}", TODAY, 'monthly', '0.5')
end

# Keyword pages
client.query("SELECT word, updated_at FROM key_words").each do |kw|
  encoded = URI.encode_www_form_component(kw['word'])
  lastmod = kw['updated_at'] ? kw['updated_at'].strftime('%Y-%m-%d') : TODAY
  add_url.call("#{SITE_URL}/researches/#{encoded}", lastmod, 'weekly', '0.6')
end

# Generate sitemap batches
batches = generate_sitemap_batches(urls)

# Generate and write each sitemap file
batches.each do |batch|
  sitemap_file = "/home/vachana/rails_apps/concord/releases/vachana/public/sitemap#{batch[:index]}.xml"
  File.write(sitemap_file, generate_xml(batch[:urls]))
  puts "Generated #{sitemap_file} with #{batch[:urls].count} URLs"
end

# Generate sitemap index
index_file = "/home/vachana/rails_apps/concord/releases/vachana/public/sitemap-index.xml"
File.write(index_file, generate_sitemap_index(batches))
puts "Generated sitemap-index.xml with #{batches.count} sitemap files"

client.close

puts "Sitemap generation complete: #{urls.count} total URLs across #{batches.count} sitemap files"
