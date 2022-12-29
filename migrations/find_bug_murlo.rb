# frozen_string_literal: true

require 'json'

class FindBugMurloMigration
  def call
    find_wrong_size
  end

  def find_wrong_size
    dups = JSON.parse(File.read('./tmp/dups-from-new.json'))
    dups.each do |data|
      original_size = data['original_size'].split('x').map(&:to_i)
      copy_size = data['copy_size'].split('x').map(&:to_i)

      if copy_size[0] > original_size[0]
        if copy_size[1] > original_size[1]
          puts %{cp "#{data['original']}" "/shared_files/test/"}
          puts %{cp "#{data['copy']}" "/shared_files/test/"}
        end
      end
    end
  end
end


FindBugMurloMigration.new.call
