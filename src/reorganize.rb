# frozen_string_literal: true

# Takes tree directories as input:
#   1) photos for reorganizing
#   2) existing photos
#   3) dups (empty directory)
# Script scans NEW_DIR. If photo exists in EXISTING_DIR then script moves
# this photo to DUPS_DIR (with the same directory structure as in NEW_DIR)
# using example
#   LOG_OUT=STDOUT LOG_LEVEL=info ruby src/reorganize.rb ~/Downloads/tmp/old ~/Downloads/tmp/new ~/Downloads/tmp/dups_from_old ~/Downloads/tmp/dups_from_new

require './src/config/initialize'
require './src/lib/meta_file_iterator'
require './src/lib/phash_comparator'

options = {
  paths_old: [],
  paths_new: [],
  path_dups_from_old: nil,
  path_dups_from_new: nil,
}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on("-o", "--old=PATH", "Directory with existing photos") do |v|
    options[:paths_old] << v
  end

  opts.on("-n", "--new=PATH", "Directory with new photos") do |v|
    options[:paths_new] << v
  end

  opts.on("-O", "--dups_from_old=PATH", "Directory for dups from directory with existing") do |v|
    options[:path_dups_from_old] = v
  end

  opts.on("-N", "--dups_from_new=PATH", "Directory for dups from new directory") do |v|
    options[:path_dups_from_new] = v
  end
end.parse!

options[:paths_new].nil? && raise('Invalid directory with new photos')
options[:paths_old].nil? && raise('Invalid directory with already existing photos')
options[:path_dups_from_old].nil? && raise('Invalid directory for dups')
options[:path_dups_from_new].nil? && raise('Invalid directory for dups')


#ii = CachingIterator.new(ImageIterator.new(path, subdirectories: true))
#ii = ImageIterator.new(path, subdirectories: true)

#ii.each_file do |file_name|
#  debug(file_name)
#  reader.read(file_name)
#end

def main(options)
  paths_old = options[:paths_old]
  paths_new = options[:paths_new]
  path_dups_from_old = options[:path_dups_from_old]
  path_dups_from_new = options[:path_dups_from_new]

  ii_old = MetaFileIterator.new(paths_old, subdirectories: true)
  ii_new = MetaFileIterator.new(paths_new, subdirectories: true)
  ii_old.preheat
  info("Prehead for old dir finished")
  ii_new.preheat
  info("Prehead for new dir finished")

  comparator = PHashComparator

  compares = 0
  start = Time.now.to_f

  dups = {
    from_new: [],
    from_old: []
  }

  ii_new.each_file do |file_new_path, data_new|
    ii_old.each_file do |file_old_path, data_old|
      phash_old = data_old['phash']
      phash_new = data_new['phash']
      next unless validate_phash(phash_old, phash_new)

      if is_phash_similar(data_old, data_new, comparator)
        dup_data = {}
        # Если размер нового файла больше, чем старого, значит нужно
        # будет заменить старый файл новым
        if File.size(data_new['fname']) > File.size(data_old['fname'])
          dup_data[:original] = data_new['fname']
          dup_data[:copy] = data_old['fname']
          dup_data[:original_source] = :new
          dup_data[:destination] = File.join(
            path_dups_from_old,
            File.basename(data_old['fname'])
          )
        else
          dup_data[:original] = data_old['fname']
          dup_data[:copy] = data_new['fname']
          dup_data[:original_source] = :old
          dup_data[:destination] = File.join(
            path_dups_from_new,
            File.basename(data_new['fname'])
          )
        end

        add_dup(dup_data, dups)
      end

      # Print progress bar
      compares += 1
      print '.' if compares % 10_000_000 == 0
    end
  end
  print "\n"

  File.write(File.join(path_dups_from_old, 'dups.txt'), JSON.pretty_generate(dups[:from_old]))
  File.write(File.join(path_dups_from_new, 'dups.txt'), JSON.pretty_generate(dups[:from_new]))

  info("compares: #{compares} in #{Time.new.to_f - start} s")
  info("dups: #{dups[:from_new].size + dups[:from_old].size}")
end

# def detect_original(data_old, data_new)
#   File.size(data_old['fname']) > File.size(data1['fname']) ? 1 : 2
# end

def validate_phash(v1, v2)
  !v1.nil? && !v2.nil?
end

def is_phash_similar(data_old, data_new, comparator)
  distance = comparator.cmp(data_old, data_new)[:distance]
  distance == 0
end

def add_dup(dup_data, dups)
  if dup_data[:original_source] = :old
    dups[:from_new] << dup_data
  end

  if dup_data[:original_source] = :new
    dups[:from_old] << dup_data
  end
end

main(options)
