require 'json'
require 'pry-byebug'

module CacheProviders
  class Files
    # @param path [String] - image path
    def initialize(path)
      @path = path
    end

    # Returns data as Hash
    def read(_ = nil)
      as_hash(read_lines)[base_name]
    end

    def write(_, record)
      data = as_hash(read_lines)
      data[base_name] = record
      write_lines(
        data.map { |name, record| "#{name}\t#{record.to_json}" }
      )
    end

    private

    def as_hash(lines)
      lines.map do |line|
        name, record = line.split("\t")
        [name, JSON.parse(record)]
      end.to_h
    end

    def read_lines
      return [] if !File.exist?(info_file)
      IO.readlines(info_file).map(&:chomp)
    end

    def write_lines(lines)
      # TODO: replace "\n" to system-independent value
      File.write(info_file, lines.join("\n"))
    end

    def base_name
      @base_name ||= File.basename(@path)
    end

    # Full path to datafile with meta info about images. Datafile
    # places in the same directory as image
    def info_file
      @info_file ||= File.join(image_dir, '_info.txt')
    end

    def image_dir
      @image_dir ||= File.dirname(@path)
    end
  end
end

#
#
#
#
# class ImageInfoCache
#   def self.get(path)
#     ImageInfoCache.new(path).get
#   end
#
#   def self.set(path, data)
#     ImageInfoCache.new(path).set(data)
#   end
#
#
#   def get
#     read_data[base_name]
#   end
#
#   def set(record)
#     # Rewrite existing data
#     data = read_data
#     data[base_name] = record
#     write_data(data)
#   end
#
#   private
#
# end