RACK_ATTACK_BLOCKED_BOTS = /Amazonbot|Amzn-SearchBot|SemrushBot|AhrefsBot|MJ12bot|DotBot|BLEXBot|PetalBot|CCBot|AspiegelBot|Cliqzbot|Baiduspider|YandexBot|Sogou|GPTBot|ChatGPT-User|OAI-SearchBot/i

Rack::Attack.blocklist('block-bots') do |req|
  req.user_agent =~ RACK_ATTACK_BLOCKED_BOTS
end

Rack::Attack.throttle('req/ip', :limit => 300, :period => 5.minutes) do |req|
  req.ip
end

Rack::Attack.throttle('search/ip', :limit => 20, :period => 1.minute) do |req|
  if req.path == '/vachanas' && req.params['vachana'].present?
    req.ip
  end
end

Rack::Attack.throttle('autocomplete/ip', :limit => 10, :period => 1.minute) do |req|
  if req.path == '/vachanas/autocomplete'
    req.ip
  end
end

Rack::Attack.throttle('logins/ip', :limit => 5, :period => 20.seconds) do |req|
  if req.path == '/login' && req.post?
    req.ip
  end
end

Rack::Attack.throttle("logins/email", :limit => 5, :period => 20.seconds) do |req|
  if req.path == '/login' && req.post?
    req.params['email'].presence
  end
end
