# frozen_string_literal: true

require './src/lib/image_info_cache'

module Readers
  # Provides a way to cache readed file. For using CachingDecorator you
  # should have any Reader. If the file exists in the cache, then Reader
  # ignores.
  # Example of using:
  # First call reads file from disk and calculate phash:
  # Readers::CachingDecorator.new(Readers::PHash.new).read(file_name)
  # Second call reads calculated phash from cache:
  # Readers::CachingDecorator.new(Readers::PHash.new).read(file_name)
  class CachingDecorator
    def initialize(reader)
      @reader = reader
      @info_cacher = {}
    end

    def read(fname)
      debug("!!! Start reading #{fname}")

      if ENV['CACHE_PROVIDER'] == 'redis'
        cache_provider = REDIS
      else
        cache_provider = CacheProviders::Files2.new(@info_cacher)
      end

      iic = ImageInfoCache.new(cache_provider)

      data = iic.read(fname)
      if data
        debug("#{data.to_json.size} bytes of data readed from cache successfully".green)
        debug("phash=#{data['phash']}")
      end
      return data if data

      debug('Read data from picture')
      data = @reader.read(fname)

      debug("Write #{data.to_s.size} bytes of data to cache")
      iic.write(fname, data)
      data
    end
  end
end
