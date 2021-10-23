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
    end

    def read(fname)
      # cache_provider = CacheProviders::Files.new(fname)
      cache_provider = REDIS

      iic = ImageInfoCache.new(cache_provider)
      data = iic.read(fname)
      return data if data

      data = @reader.read(fname)
      iic.write(fname, data)
      data
    end
  end
end
