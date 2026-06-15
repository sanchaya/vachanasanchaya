#!/usr/bin/env ruby
# frozen_string_literal: true

# Standalone sitemap generator
require 'builder'

BASE_URL = 'https://vachana.sanchaya.net'
OUTPUT_PATH = '/home/vachana/rails_apps/concord/releases/vachana/public/sitemap.xml'

# Static URLs
static_urls = [
  { loc: "#{BASE_URL}/", lastmod: '2026-06-13', changefreq: 'daily', priority: '1.0' },
  { loc: "#{BASE_URL}/about_us", lastmod: '2026-06-13', changefreq: 'monthly', priority: '0.7' },
  { loc: "#{BASE_URL}/about_us?locale=en", lastmod: '2026-06-13', changefreq: 'monthly', priority: '0.6' },
  { loc: "#{BASE_URL}/contact_us", lastmod: '2026-06-13', changefreq: 'monthly', priority: '0.7' },
  { loc: "#{BASE_URL}/help", lastmod: '2026-06-13', changefreq: 'monthly', priority: '0.7' },
  { loc: "#{BASE_URL}/vachanakaaras", lastmod: '2026-06-13', changefreq: 'weekly', priority: '0.9' },
  { loc: "#{BASE_URL}/vachanas/vachana_concord", lastmod: '2026-06-13', changefreq: 'weekly', priority: '0.9' },
  { loc: "#{BASE_URL}/researches", lastmod: '2026-06-13', changefreq: 'weekly', priority: '0.8' },
  { loc: "#{BASE_URL}/glossaries", lastmod: '2026-06-13', changefreq: 'weekly', priority: '0.8' },
]

# Alphabet letters
all_letters = %w[ಅ ಆ ಇ ಈ ಉ ಊ ಋ ೠ ಎ ಏ ಐ ಒ ಓ ಔ ಅಂ ಅಃ ಕ ಖ ಗ ಘ ಙ ಚ ಛ ಜ ಝ ಞ ಟ ಠ ಡ ಢ ಣ ತ ಥ ದ ಧ ನ ಪ ಫ ಬ ಭ ಮ ಯ ರ ಱ ಲ ವ ಶ ಷ ಸ ಹ ಳ]

# Generate alphabet navigation URLs
alphabet_urls = []
all_letters.each do |letter|
  alphabet_urls << { loc: "#{BASE_URL}/vachanakaaras?start_letter=#{URI.encode_www_form_component(letter)}", lastmod: '2026-06-13', changefreq: 'weekly', priority: '0.7' }
  alphabet_urls << { loc: "#{BASE_URL}/vachanas/vachana_concord?start_letter=#{URI.encode_www_form_component(letter)}", lastmod: '2026-06-13', changefreq: 'weekly', priority: '0.7' }
  alphabet_urls << { loc: "#{BASE_URL}/researches?start_letter=#{URI.encode_www_form_component(letter)}", lastmod: '2026-06-13', changefreq: 'weekly', priority: '0.6' }
end

# We need to get vachanakaara and vachana IDs from database
# For now, we'll create a placeholder comment
# In production, run: ruby script/generate_sitemap.rb

# Vachanakaara URLs (placeholder - will be filled by database query)
vachanakaara_urls = []
# Vachana URLs (placeholder)
vachana_urls = []

# Build XML
xml = Builder::XmlMarkup.new(indent: 2)
xml.instruct! :xml, version: '1.0', encoding: 'UTF-8'
xml.urlset(xmlns: 'http://www.sitemaps.org/schemas/sitemap/0.9') do
  (static_urls + alphabet_urls).each do |url|
    xml.url do
      xml.loc url[:loc]
      xml.lastmod url[:lastmod]
      xml.changefreq url[:changefreq]
      xml.priority url[:priority]
    end
  end
end

File.write(OUTPUT_PATH, xml.target!)
puts "Sitemap generated: #{OUTPUT_PATH}"
puts "Total URLs: #{static_urls.length + alphabet_urls.length}"
puts ""
puts "NOTE: To include all vachanakaara and vachana pages, run this on the server with Rails loaded:"
puts "  RAILS_ENV=production bundle exec rake sitemap:generate"
