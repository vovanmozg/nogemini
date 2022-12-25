# frozen_string_literal: true

module CacheProviders
  class Files2
    class InfoFileAccessor
      class << self
        attr_accessor :threads
      end

      @@cache = {}
      @threads = []
      @last_writed_crc = nil

      def self.read(file_name)
        debug_data = @@cache[file_name] && @@cache[file_name][:data] ? @@cache[file_name][:data].keys : ''
        debug("InfoFileAccessor.read(keys: #{debug_data})".green)
        if @@cache[file_name]
          return @@cache[file_name][:data]
        end

        debug('start reading info file'.blue)

        init_cache(file_name, {})

        @@cache[file_name][:semaphore].synchronize do
          debug("start real reading info file, keys:#{@@cache[file_name][:data].keys}".black_on_yellow)
          @@cache[file_name][:data] = JSON.parse(File.read(file_name))
        end

        debug('finish reading info file'.blue)
        Marshal.load(Marshal.dump(@@cache[file_name][:data]))
      end

      def self.write(file_name, data)
        data = Marshal.load(Marshal.dump(data))
        debug("InfoFileAccessor.write(keys: #{data.keys})".green)
        init_cache(file_name, data)
        @@cache[file_name][:data].merge!(data)

        @threads << Thread.new do
          size = @@cache[file_name][:data].keys.size
          debug("start async writing info file size:#{size}, keys:#{@@cache[file_name][:data].keys}".yellow)
          @@cache[file_name][:semaphore].synchronize do

            new_crc = Zlib::crc32(@@cache[file_name][:data].to_s)
            Thread.exit() if @last_writed_crc == new_crc

            @last_writed_crc = new_crc

            size = @@cache[file_name][:data].keys.size
            debug("start real writing info file size:#{size}, keys:#{@@cache[file_name][:data].keys}".black_on_yellow)
            info("start real writing info file size:#{size}}".black_on_yellow)

            File.write(file_name, @@cache[file_name][:data].to_json)
            debug("finish real writing info file size:#{size}, keys:#{@@cache[file_name][:data].keys}".black_on_yellow)
            info("finish real writing info file size:#{size}".black_on_yellow)
          end
          debug("end async writing info file size:#{size}, keys:#{@@cache[file_name][:data].keys}".yellow)
        end
      end

      def self.init_cache(file_name, data)
        debug("InfoFileAccessor.init_cache(#{file_name}, #{data.keys})".green)
        if @@cache[file_name]
          debug("return because info file cache exists")
          return
        end

        debug("init #{file_name} cache")
        @@cache[file_name] = {
          data: data,
          semaphore: Mutex.new
        }
      end
    end
  end
end
