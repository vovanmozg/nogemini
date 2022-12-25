# frozen_string_literal: true

require './src/lib/cache_providers/files2/info_file_accessor'

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
      debug("Files2#read(#{path})".green)
      @path = path
      unless File.exist?(info_file)
        debug("file #{info_file} missing")
        write(path, {})
        return
      end
      # data = @info_cacher[info_file]
      info_hash[base_name]
    end

    def write(path, record)
      debug("Files2#write(#{path})".green)
      @path = path
      debug("Write data to #{info_file}. size: #{record.to_s.size}")
      data = info_hash
      cleanup(record)
      data[base_name] = record

      #File.write(info_file, data.to_json)
      InfoFileAccessor.write(info_file, data)
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

    def info_hash
      return {} unless File.exist?(info_file)

      InfoFileAccessor.read(info_file)
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

