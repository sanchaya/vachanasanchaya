# Throttle requests to 5 requests per second per ip
Rack::Attack.throttle('req/ip', :limit => 60, :period => 1.minute) do |req|
  # If the return value is truthy, the cache key for the return value
  # is incremented and compared with the limit. In this case:
  #   "rack::attack:#{Time.now.to_i/1.second}:req/ip:#{req.ip}"
  #
  # If falsy, the cache key is neither incremented nor checked.

  req.ip
end


Rack::Attack.throttled_response = lambda do |env|
  # name and other data about the matched throttle
  # body = [
  #   env['rack.attack.matched'],
  #   env['rack.attack.match_type'],
  #   env['rack.attack.match_data']
  #   ].inspect

  # Using 503 because it may make attacker think that they have successfully
  # DOSed the site. Rack::Attack returns 429 for throttling by default
  # [ 503, {}, [body]]
  [ 503, {}, ["ವಚನ ಸಂಚಯವನ್ನು ನಿಧಾನವಾಗಿ ಓದಿ... ದಯವಿಟ್ಟು ಸ್ವಲ್ಪ ಸಮಯದ ನಂತರ ಪುನಃ ಪ್ರಯತ್ನಿಸಿ "]]
end