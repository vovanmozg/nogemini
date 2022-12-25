# frozen_string_literal: true

module CacheProviders
  class Files2
    class InfoFileAccessor
      class << self
        attr_accessor :threads
      end

      @cache = {}
      @threads = []
      @last_writed_crc = nil
      @file_semaphores = {}
      @hash_semaphores = {}
      @counter = 0

      def self.read(file_name)
        # debug_data = @@cache[file_name] && @@cache[file_name][:data] ? @@cache[file_name][:data].keys : ''
        # debug("InfoFileAccessor.read(keys: #{debug_data})".green)
        debug("InfoFileAccessor.read()".green)
        data = read_cache(file_name)
        return data if data

        debug('start reading info file'.blue)

        init_cache(file_name, {})

        content = read_file(file_name)

        start = Time.now.to_f
        data = JSON.parse(content)
        debug("JSON.parse took #{Time.now.to_f - start} s")

        write_cache(file_name, data)
        data
        # debug('finish reading info file'.blue)
        # read_cache(file_name)
      end

      def self.write(file_name, data)
        # debug("InfoFileAccessor.write(keys: #{data.keys.size})".green)
        debug("InfoFileAccessor.write()".green)
        # data = Marshal.load(Marshal.dump(data))

        init_cache(file_name, data)
        add_to_cache(file_name, data)

        @counter += 1

        @threads << Thread.new do
          sleep(15)
          #size = read_cache(file_name).keys.size
          # debug("start async writing info file size:#{size}, keys:#{read_cache(file_name).keys}".yellow)
          #debug("start async writing info file size:#{size}".yellow)

          new_crc = Zlib::crc32(read_cache(file_name).to_s)
          debug("crc new: #{new_crc}, old: #{@last_writed_crc}")
          if @last_writed_crc == new_crc
            debug("Skip writing because crc not modified".blue)
            Thread.exit()
          end
          @last_writed_crc = new_crc


          #size = read_cache(file_name).keys.size
          # debug("start real writing info file size:#{size}, keys:#{read_cache(file_name).keys}".black_on_yellow)
          #debug("start real writing info file size:#{size}".black_on_yellow)
          #info("start real writing info file size:#{size}}".black_on_yellow)

          write_file(file_name, read_cache(file_name))

          # debug("finish real writing info file size:#{size}, keys:#{read_cache(file_name).keys}".black_on_yellow)
          #debug("finish real writing info file size:#{size}".black_on_yellow)
          #info("finish real writing info file size:#{size}".black_on_yellow)
          # debug("end async writing info file size:#{size}, keys:#{read_cache(file_name).keys}".yellow)
          #debug("end async writing info file size:#{size}}".yellow)
        end
      end

      def self.init_cache(file_name, data)
        # debug("InfoFileAccessor.init_cache(#{file_name}, #{data.keys.size})".green)
        debug("InfoFileAccessor.init_cache(#{file_name})".green)

        unless @file_semaphores[file_name]
          @file_semaphores[file_name] = Mutex.new
        end

        unless @hash_semaphores[file_name]
          @hash_semaphores[file_name] = Mutex.new
        end

        unless read_cache(file_name)
          debug("init #{file_name} cache")
          write_cache(file_name, data)
          # debug("return because info file cache exists")
        end

      end

      def self.read_cache(file_name)
        debug("InfoFileAccessor.read_cache()".green)
        return unless @hash_semaphores[file_name]

        x = @hash_semaphores[file_name].synchronize do
          @cache[file_name]
        end
        debug("finish InfoFileAccessor.read_cache()".green)
        x
      end

      def self.write_cache(file_name, data)
        debug("InfoFileAccessor.write_cache()".green)
        x = @hash_semaphores[file_name].synchronize do
          @cache[file_name] = data
        end
        debug("finish InfoFileAccessor.write_cache()".green)
        x
      end

      def self.add_to_cache(file_name, new_data)
        data = read_cache(file_name)
        write_cache(file_name, data.merge(new_data))
      end

      def self.read_file(file_name)
        @file_semaphores[file_name].synchronize do
          debug("start real reading info file}".black_on_yellow)
          File.read(file_name)
        end
      end

      def self.write_file(file_name, data)
        start = Time.now.to_f
        content = data.to_json
        debug("to_json took #{Time.now.to_f - start} s")
        @file_semaphores[file_name].synchronize do
          start = Time.now.to_f
          File.write(file_name, content)
          debug("writing took #{Time.now.to_f - start} s")
        end
      end
    end
  end
end
