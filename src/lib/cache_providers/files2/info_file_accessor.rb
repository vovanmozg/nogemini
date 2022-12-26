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
        data = read_cache(file_name)
        return data if data

        init_cache(file_name, {})

        content = read_file(file_name)

        start = Time.now.to_f
        data = JSON.parse(content)
        debug("JSON.parse took #{Time.now.to_f - start} s")

        write_cache(file_name, data)
        data
      end

      def self.write(file_name, data)
        init_cache(file_name, data)
        add_to_cache(file_name, data)

        @counter += 1

        thread = Thread.new do
          sleep(15)

          new_crc = Zlib::crc32(read_cache(file_name).to_s)
          if @last_writed_crc == new_crc
            debug("[#{Thread.current.object_id}] Skip writing because crc not modified".blue)
            @threads.delete(Thread.current.object_id)
            Thread.exit()
          end
          @last_writed_crc = new_crc

          write_file(file_name, read_cache(file_name))
        end
        @threads[thread.object_id] == thread
      end

      def self.init_cache(file_name, data)
        unless @file_semaphores[file_name]
          @file_semaphores[file_name] = Mutex.new
        end

        unless @hash_semaphores[file_name]
          @hash_semaphores[file_name] = Mutex.new
        end

        unless read_cache(file_name)
          write_cache(file_name, data)
        end

      end

      def self.read_cache(file_name)
        return unless @hash_semaphores[file_name]

        @hash_semaphores[file_name].synchronize do
          @cache[file_name]
        end
      end

      def self.write_cache(file_name, data)
        @hash_semaphores[file_name].synchronize do
          @cache[file_name] = data
        end
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
