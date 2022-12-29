require 'progressbar'

class MetaFileIterator
  def initialize(paths, subdirectories: false)
    @info_files_groups = {}
    paths.each do |path|
      glob_path = subdirectories ? "#{path}/**/_info.json" : "#{path}/_info.json"
      @info_files_groups[path] = Dir.glob(glob_path)
    end
  end

  def preheat
    @files = {}
    @info_files_groups.each do |root_path, info_files|
      info_files.each do |info_file|
        dir_path = File.dirname(info_file)
        info_file_data = read_info_file_data(info_file)
        info_file_data.each do |img_file_name, data|
          data['root_path'] = root_path
          @files[File.join(dir_path, img_file_name)] = data
        end
      end
    end
    info("files in comparing set of dirs: #{@files.size}")
  end

  def each_file(&block)
    @files.each do |img_file_name, data|
      data['file_name'] = img_file_name
      block.call(img_file_name, data)
    end
  end

  def read_info_file_data(info_file)
    return [] if !File.exist?(info_file)

    JSON.parse(File.read(info_file))
  end
end
