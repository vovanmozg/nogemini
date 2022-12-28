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
require './src/lib/dups_finder'

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

  # priority can be new or old
  opts.on("-p", "--priority=PRIORITY", "Force priority for old or new directory") do |v|
    options[:priority] = v
  end
end.parse!

options[:paths_new].nil? && raise('Invalid directory with new photos')
options[:paths_old].nil? && raise('Invalid directory with already existing photos')
if options[:priority] == 'old'
  options[:path_dups_from_old].nil? && raise('Invalid directory for dups')
end
if options[:priority] == 'new'
  options[:path_dups_from_new].nil? && raise('Invalid directory for dups')
end

#ii = CachingIterator.new(ImageIterator.new(path, subdirectories: true))
#ii = ImageIterator.new(path, subdirectories: true)

#ii.each_file do |file_name|
#  debug(file_name)
#  reader.read(file_name)
#end


stat = DupsFinder.new.call(options)
info(stat)
