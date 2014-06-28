require 'sidekiq/api'

redis_config = { url: "redis://#{ENV.fetch('REDIS_PORT_6379_TCP_ADDR', 'localhost')}:#{ENV.fetch('REDIS_PORT_6379_TCP_PORT', '6379')}", namespace: 'sidekiq' }

Sidekiq.configure_server do |config|
  config.redis = redis_config
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end
