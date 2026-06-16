#!/usr/bin/env ruby
# Replace backticks (`) with double quotes (") in all vachana records

require 'mysql2'

DB_CONFIG = {
  host: 'localhost',
  username: 'vachana_concord',
  password: ENV['DB_PASSWORD'] || raise("Set DB_PASSWORD environment variable"),
  database: 'vachana_concord',
  encoding: 'utf8'
}

client = Mysql2::Client.new(DB_CONFIG)

# Dry run: count records with backticks
count_result = client.query("SELECT COUNT(*) AS cnt FROM vachanas WHERE vachana LIKE '%`%'")
affected = count_result.first['cnt']

puts "Records containing backtick (`): #{affected}"

if affected == 0
  puts "No backticks found. Nothing to do."
  client.close
  exit 0
end

# Show some examples
puts "\nSample records with backticks:"
samples = client.query("SELECT id, vachana FROM vachanas WHERE vachana LIKE '%`%' LIMIT 5")
samples.each do |row|
  excerpt = row['vachana'][0..120].gsub("\n", "\\n")
  puts "  id=#{row['id']}: #{excerpt}"
end

# Perform the replacement
puts "\nReplacing backticks with double quotes in all #{affected} records..."
client.query("UPDATE vachanas SET vachana = REPLACE(vachana, '`', '\"') WHERE vachana LIKE '%`%'")

# Verify
verify = client.query("SELECT COUNT(*) AS cnt FROM vachanas WHERE vachana LIKE '%`%'")
remaining = verify.first['cnt']
puts "Remaining backtick records: #{remaining}"
puts "Done."

client.close