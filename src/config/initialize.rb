require 'zlib'
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require './src/config/logger'
require './src/lib/cache_providers/redis'
require './src/lib/cache_providers/files'
require './src/lib/cache_providers/files2'
require './src/lib/cache_providers/files3'

REDIS = CacheProviders::Redis.new
