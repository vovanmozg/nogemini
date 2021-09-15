# Calculates phash for input files and cache result to _info.txt in the
# directory where the files placed.
# Using example
# ruby calculate-phash.rb /path/to/images

require './src/config/initialize'
require './src/lib/image_iterator'
require './src/lib/phash_comparator'
require './src/lib/actions/cache'

path = ARGV[0] || raise('Invaid directory')
output = ARGV[1] || raise('Invaid output file')

ii = ImageIterator.new(path, subdirectories: true)
compare = PHashComparator
action = Actions::Cache.new(output)
ii.each_pair(compare, action)

# ii.each_pair do |f1, f2|
#   phash1 = NGPHash.calculate(f1)
#   phash2 = NGPHash.calculate(f2)
#
#   distance = NGPHash.distance(phash1, phash2)
#   p distance, f1, f2 if distance == 2
# end
