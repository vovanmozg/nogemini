module Actions
  class Cache
    def initialize(file_name)
      @file_name = file_name
    end

    def run(f1, f2, compare_result)
      # debug(compare_result)
      #puts f1
      key = [f1['fname'], f2['fname']].sort.join.to_json
      write(key, compare_result)
    end

    def write(key, value)
      REDIS.write("compare_result:#{key}", value)
    end
  end
end
