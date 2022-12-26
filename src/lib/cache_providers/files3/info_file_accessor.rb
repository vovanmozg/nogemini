# frozen_string_literal: true

module CacheProviders
  class Files3
    class InfoFileAccessor
      class << self
        attr_accessor :threads
      end

      @cache = {}
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

        bulk_size = 10
        if @counter % bulk_size
          write_file(file_name, read_cache(file_name))
        end
      end

      def self.finish
        @cache.each do |file_name, data|
          write_cache(file_name, data)
        end
      end

      def self.init_cache(file_name, data)
        unless read_cache(file_name)
          write_cache(file_name, data)
        end
      end

      def self.read_cache(file_name)
        @cache[file_name]
      end

      def self.write_cache(file_name, data)
        @cache[file_name] = data
      end

      def self.add_to_cache(file_name, new_data)
        data = read_cache(file_name)
        write_cache(file_name, data.merge(new_data))
      end

      def self.read_file(file_name)
        debug("start real reading info file}".black_on_yellow)
        File.read(file_name)
      end

      def self.write_file(file_name, data)
        info("Writing file #{file_name}".blue)
        start = Time.now.to_f
        content = data.to_json
        debug("to_json took #{Time.now.to_f - start} s")

        start = Time.now.to_f
        File.write(file_name, content)
        debug("writing took #{Time.now.to_f - start} s")
      end
    end
  end
end
