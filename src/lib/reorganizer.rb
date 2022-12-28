# frozen_string_literal: true

require 'fileutils'

class Reorganizer
  def call(file: nil, destination: nil, mode: :bash)
    dups = JSON.parse(File.read(file))

    moved = {}
    already_moved = []

    commands = []
    dups.each do |dup_info|
      if moved[dup_info['copy']]
        already_moved << dup_info
        next
      end

      dir_path = File.dirname(dup_info['destination'])
      if mode == :now
        FileUtils.mkdir_p(dir_path) unless Dir.exist?(dir_path)
        FileUtils.move(dup_info['copy'], dup_info['destination'])
      elsif mode == :bash
        commands << 'mkdir -p "' + dir_path + '"' unless Dir.exist?(dir_path)
        commands << 'mv "' + dup_info['copy'] + '" "' + dup_info['destination'] + '"'
      end

      moved[dup_info['copy']] = true
    end

    if mode == :bash
      commands_file = File.join(File.dirname(file), 'commands.sh.txt')
      File.write(commands_file, commands.join("\n"))
    end

    {
      for_moving: dups.size,
      moved: moved.keys.size,
      already_moved: already_moved.size
    }
  end
end
