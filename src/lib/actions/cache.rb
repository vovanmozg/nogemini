module Actions
  class Cache
    def initialize(file_name)
      @file_name = file_name
    end

    def run(f1, f2, compare_result)
      # debug(compare_result)

      key = [f1, f2].sort.join.to_json
      REDIS.write(key, compare_result)
    end
  end
end
