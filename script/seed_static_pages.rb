#!/usr/bin/env ruby
# Seed script for static pages - run with: ruby script/seed_static_pages.rb

require File.expand_path('../../config/environment', __FILE__)

pages = [
  {
    slug: 'about_us',
    title: 'ನಮ್ಮ ಬಗ್ಗೆ',
    locale: 'kn',
    body: File.read(Rails.root.join('app/views/home/_about_content.kn.html.erb'))
  },
  {
    slug: 'about_us',
    title: 'About Us',
    locale: 'en',
    body: File.read(Rails.root.join('app/views/home/_about_content.en.html.erb'))
  },
  {
    slug: 'help',
    title: 'ಸಹಾಯ',
    locale: 'kn',
    body: File.read(Rails.root.join('app/views/home/help.html.erb'))
  },
  {
    slug: 'help',
    title: 'Help',
    locale: 'en',
    body: '<div style="max-width:800px;margin:0 auto;padding:20px;">
  <h1 style="font-size:26px;color:#333;text-align:center;padding:20px 0;">Help - Vachana Sanchaya User Guide</h1>
  <p>English help content will be added here.</p>
</div>'
  }
]

pages.each do |page_data|
  page = StaticPage.find_or_initialize_by(slug: page_data[:slug], locale: page_data[:locale])
  page.title = page_data[:title]
  page.body = page_data[:body]
  if page.save
    puts "Created/Updated: #{page.title} (#{page.locale})"
  else
    puts "Error: #{page.errors.full_messages.join(', ')}"
  end
end

puts "Static pages seeded successfully!"