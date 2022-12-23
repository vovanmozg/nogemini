require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require './src/config/logger'
require './src/lib/cache_providers/redis'
require './src/lib/cache_providers/files'

REDIS = CacheProviders::Redis.new
