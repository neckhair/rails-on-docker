require 'sidekiq/api'

redis_config = {
  url: 'redis://redis:6379',
  password: ENV.fetch('REDIS_PASSWORD', nil),
}

Sidekiq.configure_server do |config|
  config.redis = redis_config
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end
