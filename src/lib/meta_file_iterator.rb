require 'progressbar'

class MetaFileIterator
  def initialize(path, subdirectories: false)
    @path = path
    glob_path = subdirectories ? "#{path}/**/_info.json" : "#{path}/_info.json"
    @info_files = Dir.glob(glob_path)
  end

  def preheat
    @files = {}
    @info_files.map do |info_file|
      dir_path = File.dirname(info_file)
      info_file_data = read_info_file_data(info_file)
      info_file_data.each do |img_file_name, data|
        # key = info_file + '/' + img_file_name
        #@files[info_file] = {} unless @files[info_file]
        @files[File.join(dir_path, img_file_name)] = data
      end
    end.flatten
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
