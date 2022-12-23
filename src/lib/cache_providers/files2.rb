require 'json'
require 'pry-byebug'

module CacheProviders
  class Files2
    # @param path [String] - image path
    # @param info_cacher [] - mechanism to decrease serialize/deserialize
    #        and read/write to _info.txt
    def initialize(info_cacher)
      @info_cacher = info_cacher
    end

    # Returns data as Hash
    def read(path)
      @path = path
      return unless File.exist?(info_file)
      # data = @info_cacher[info_file]
      info_hash[base_name]
    end

    def write(path, record)
      @path = path
      debug("Write data to #{info_file}")
      data = info_hash
      cleanup(record)
      data[base_name] = record

      File.write(info_file, data.to_json)
    end

    private

    # Removes bad strings. Mutates record
    def cleanup(record)
      record.each do |k, v|
        begin
          v.to_json
        rescue JSON::GeneratorError => error
          record[k] = ''
        end
      end
    end

    def base_name
      @base_name ||= File.basename(@path)
    end

    def info_hash
      return {} unless File.exist?(info_file)

      JSON.parse(IO.read(info_file))
    end

    def base_name
      @base_name ||= File.basename(@path)
    end

    # Full path to datafile with meta info about images. Datafile
    # places in the same directory as image
    def info_file
      @info_file ||= File.join(image_dir, '_info.json')
    end

    def image_dir
      @image_dir ||= File.dirname(@path)
    end
  end
end

