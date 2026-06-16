Rack::Attack.throttle('req/ip', :limit => 300, :period => 5.minutes) do |req|
  req.ip
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
