require 'sidekiq/api'

redis_config = { url: 'redis://redis1.redis.dev.docker:6379', namespace: 'sidekiq' }

Sidekiq.configure_server do |config|
  config.redis = redis_config
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end
