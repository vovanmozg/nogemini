# frozen_string_literal: true

# Takes tree directories as input:
#   1) photos for reorganizing
#   2) existing photos
#   3) dups (empty directory)
# Script scans NEW_DIR. If photo exists in EXISTING_DIR then script moves
# this photo to DUPS_DIR (with the same directory structure as in NEW_DIR)
# using example
#   LOG_OUT=STDOUT LOG_LEVEL=info ruby src/reorganize.rb ~/Downloads/tmp/old ~/Downloads/tmp/new ~/Downloads/tmp/dups

require './src/config/initialize'
require './src/lib/meta_file_iterator'
require './src/lib/phash_comparator'

path_old = ARGV[0] || raise('Invalid directory with already existing photos')
path_new = ARGV[1] || raise('Invalid directory with new photos')
path_dups = ARGV[2] || raise('Invalid directory for dups')



#ii = CachingIterator.new(ImageIterator.new(path, subdirectories: true))
#ii = ImageIterator.new(path, subdirectories: true)

#ii.each_file do |file_name|
#  debug(file_name)
#  reader.read(file_name)
#end
def main(path_old, path_new, path_dups)
  ii_old = MetaFileIterator.new(path_old, subdirectories: true)
  ii_new = MetaFileIterator.new(path_new, subdirectories: true)
  p Time.now
  ii_old.preheat
  p Time.now
  ii_new.preheat
  p Time.now

  comparator = PHashComparator


  cmps = {}


  compares = 0
  actual = 0
  start = Time.now.to_f

  # set_new = Set.new
  # set_old = Set.new

  dups = []

  ii_new.each_file do |file_new_path, data_new|
    ii_old.each_file do |file_old_path, data_old|
      phash_new = data_new['phash']
      phash_old = data_old['phash']
      next if phash_new.nil? || phash_old.nil?

      # set_new << phash_new
      # set_old << phash_old


      cmps[phash_new] = {} if cmps[phash_new].nil?


      if cmps[phash_new][phash_old].nil?
        if data_old['file_name'] =~ %r{'/Users/vovanmozg/Downloads/tmp/new'}
          f = 1
        end
        add_dup(data_old, data_new, dups) if is_phash_similar(data_old, data_new, comparator)

        actual += 1
      end

      compares += 1

      print '.' if compares % 10_000_000 == 0



    end
  end

  File.write(File.join(path_dups, 'dups.txt'), JSON.pretty_generate(dups))

  p "compares: #{compares}/#{actual} in #{Time.new.to_f - start} s"
  p "dups: #{dups.size}"
  #p cmps
  #p set_new.size
  #p set_old.size

end

def is_phash_similar(data_old, data_new, comparator)
  distance = comparator.cmp(data_old, data_new)[:distance]
  distance == 0
end

def add_dup(data_old, data_new, dups)

  dups << [data_old['file_name'], data_new['file_name']]
end

main(path_old, path_new, path_dups)
