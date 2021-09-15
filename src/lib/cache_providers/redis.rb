require 'redis'

module CacheProviders
  class Redis
    def initialize
      @redis = ::Redis.new
    end

    # Returns data as Hash
    def read(key)
      raw = @redis.get(key)
      raw && JSON.parse(raw)
    end

    def write(key, record)
      @redis.set(key, record.to_json)
    end
  end
end