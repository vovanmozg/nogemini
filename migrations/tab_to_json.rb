# frozen_string_literal: true

require 'json'

class TabToJsonMigration
  def call
    path = ARGV[0] || raise('Invalid directory')
    info_files = Dir.glob("#{path}/**/_info.txt")

    info_files.each do |file_name|
      @path = file_name

      if version(file_name) == :old
        data = as_hash(read_lines)

        File.rename(file_name, "#{file_name}.old")
        IO.write(file_name, data.to_json)
      else
        p "File #{File.basename(file_name)} already converted"
      end

    end
  end

  private

  def version(file_name)
    data = IO.read(file_name)
    JSON.parse(data)
    :new
  rescue JSON::ParserError
    :old
  end

  def as_hash(lines)
    lines.map do |line|
      name, record = line.split("\t")
      [name, JSON.parse(record)]
    end.to_h
  end

  def read_lines
    return [] if !File.exist?(info_file)

    IO.readlines(info_file).map(&:chomp)
  end

  # Full path to datafile with meta info about images. Datafile
  # places in the same directory as image
  def info_file
    @info_file ||= File.join(image_dir, '_info.txt')
  end

  def image_dir
    @image_dir ||= File.dirname(@path)
  end
end


TabToJsonMigration.new.call
