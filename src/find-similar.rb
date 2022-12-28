# OBSOLETE

# Calculates phash for input files and cache result to _info.txt in the
# directory where the files placed.
# Using example
# ruby calculate-phash.rb /path/to/images

require './src/config/initialize'
require './src/lib/image_iterator'
require './src/lib/phash_comparator'
require './src/lib/actions/cache'
require './src/lib/readers/caching_decorator'
require './src/lib/readers/chain'
require './src/lib/readers/image_props'
require './src/lib/readers/phash'

path = ARGV[0] || raise('Invaid directory')
output = ARGV[1] || raise('Invaid output file')


# source - ImageInfoCache
# output - redis



# Iterate files without needing preindexing
ii = ImageIterator.new(path, subdirectories: true)
reader = Readers::CachingDecorator.new(
  Readers::Chain.new([
    Readers::PHash.new,
    Readers::ImageProps.new
  ])
)
comparator = PHashComparator
action = Actions::Cache.new(output)
ii.each_pair(reader, comparator, action)

