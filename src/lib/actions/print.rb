module Actions
  class Print
    def initialize(file_name)
      @file_name = file_name
    end

    def run(f1, f2, compare_result)
      debug(compare_result)

      line = "#{f1}\t#{f2}\t#{compare_result}\n"
      IO.write(@file_name, line, mode: 'a')
    end
  end
end
