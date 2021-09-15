# Calculates phash by filename and caches value with ImageInfoCache
require 'pry-byebug'
require 'phashion'
require './src/lib/image_info_cache'

# TODO: move out caching
class NGPHash
  def self.calculate(file_name)
    #cache_provider = CacheProviders::Files.new(file_name)
    cache_provider = REDIS

    iic = ImageInfoCache.new(cache_provider)
    data = iic.read(file_name)
    return data['phash'] if data

    phash = Phashion.image_hash_for(file_name)
    iic.write(file_name, phash: phash)
    phash
  end

  def self.distance(phash1, phash2)
    Phashion.hamming_distance(phash1, phash2)
  end
end
