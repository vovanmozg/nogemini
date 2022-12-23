require 'redis'

module CacheProviders
  class Redis
    def initialize
      @redis = ::Redis.new
    end

    # Returns data as Hash
    def read(key)
      raw = @redis.get(prefixed_key(key))
      raw && JSON.parse(raw)
    end

    def write(key, record)
      @redis.set(prefixed_key(key), record.to_json)
    end

    def prefixed_key(key)
      "iic:#{key}"
    end
  end
end
