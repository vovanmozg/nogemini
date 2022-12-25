# Cache image meta info to _info.txt file in human-readable format
#
# 1.jpg  {"phash":"123123123123123"}
# 2.jpg  {"phash":"444"}
#
# Info file is placed in the same directory of the image
# One row contain info about one file. Every row contain 2 value
# separated by "\t". The first value is file name. The second - json
# with data

require 'json'

class ImageInfoCache
  # def self.get(path)
  #   ImageInfoCache.new(path).get
  # end
  #
  # def self.set(path, data)
  #   ImageInfoCache.new(path).set(data)
  # end

  # @param cache_provider [CacheProvider::*]
  def initialize(cache_provider)
    @cache_provider = cache_provider
  end

  def read(key = nil)
    debug("ImageInfoCache#read(#{key})".green)
    @cache_provider.read(key)
  end

  def write(key = nil, record = {})
    debug("ImageInfoCache#write(#{key}, size: #{record.to_s.size})".green)
    @cache_provider.write(key, record)
    # return
    # Rewrite existing data
    # data = @cache_provider.read
    # data[base_name] = record
    # @cache_provider.write(data)
  end

  private

  # Returns data as Hash
  # def read_data
  #   read_lines.map do |line|
  #     name, record = line.split("\t")
  #     [name, JSON.parse(record)]
  #   end.to_h
  # end
  #
  # def write_data(data)
  #   write_lines(
  #     data.map { |name, record| "#{name}\t#{record.to_json}" }
  #   )
  # end
  #
  # def read_lines
  #   return [] if !File.exist?(info_file)
  #   IO.readlines(info_file).map(&:chomp)
  # end
  #
  # def write_lines(lines)
  #   # TODO: replace "\n" to system-independent value
  #   File.write(info_file, lines.join("\n"))
  # end
  #
  # def base_name
  #   @base_name ||= File.basename(@path)
  # end
  #
  # # Full path to datafile with meta info about images. Datafile
  # # places in the same directory as image
  # def info_file
  #   @info_file ||= File.join(image_dir, '_info.txt')
  # end
  #
  # def image_dir
  #   @image_dir ||= File.dirname(@path)
  # end
end
