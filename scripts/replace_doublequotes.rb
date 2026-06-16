#!/usr/bin/env ruby
# Replace double quotes (") with single quotes (') in all vachana records

require 'mysql2'

DB_CONFIG = {
  host: 'localhost',
  username: 'vachana_concord',
  password: ENV['DB_PASSWORD'] || raise("Set DB_PASSWORD environment variable"),
  database: 'vachana_concord',
  encoding: 'utf8'
}

client = Mysql2::Client.new(DB_CONFIG)

count = client.query("SELECT COUNT(*) AS cnt FROM vachanas WHERE vachana LIKE '%\"%'")
affected = count.first['cnt']
puts "Records with double quotes: #{affected}"

if affected > 0
  client.query("UPDATE vachanas SET vachana = REPLACE(vachana, '\"', \"'\") WHERE vachana LIKE '%\"%'")
  remain = client.query("SELECT COUNT(*) AS cnt FROM vachanas WHERE vachana LIKE '%\"%'")
  puts "Remaining double quotes: #{remain.first['cnt']}"
  puts "Replaced #{affected} records."
else
  puts "No double quotes found."
end

client.close