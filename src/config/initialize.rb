require './src/config/logger'
require './src/lib/cache_providers/redis'

REDIS = CacheProviders::Redis.new
