require 'progressbar'

class ImageIterator
  def initialize(path, exts: /(jpeg|jpg|png)$/i, subdirectories: false)
    glob_path = subdirectories ? "#{path}/**/*" : "#{path}/*"
    @files = Dir.glob(glob_path).select { |file| file =~ /(jpeg|jpg|png)$/i }
  end

  def each_file(&block)
    return @files unless block

    @files.each do |file_name|
      block.call(file_name)
    end
  end

  # Example of using:
  # ImageIterator.new(path).each_pair { |f1, f2| ...  }
  # f1, f2 - full names of files. Each pair processes once.
  # For 4 files there are 6 compares. Demo:
  # files: 1, 2, 3, 4
  # compares:
  # 1, 2
  # 1, 3
  # 1, 4
  # 2, 3
  # 2, 4
  # 3, 4
  def each_pair(strategy = nil, action = nil, &block)
    combinations = @files.combination(2)
    bar = ProgressBar.create(total: combinations.size)
    combinations.each do |f1, f2|
      bar.increment
      if strategy && action

        compare_result = strategy.cmp(f1, f2)
        action.run(f1, f2, compare_result)
      else
        yield f1, f2
      end
    end
  end
end
