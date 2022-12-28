# frozen_string_literal: true

require 'fileutils'

class Reorganizer
  def call(file)
    dups = JSON.parse(File.read(file))

    moved = {}
    already_moved = []

    dups.each do |dup_info|
      if moved[dup_info['copy']]
        already_moved << dup_info
        next
      end

      dir_path = File.dirname(dup_info['destination'])
      FileUtils.mkdir_p(dir_path) unless Dir.exist?(dir_path)
      FileUtils.move(dup_info['copy'], dup_info['destination'])

      moved[dup_info['copy']] = true
    end

    {
      for_moving: dups.size,
      moved: moved.keys.size,
      already_moved: already_moved.size
    }
  end
end
