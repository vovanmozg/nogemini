# Calculates phash for input files and cache result to _info.txt in the
# directory where the files placed.
# Using example
# ruby calculate-phash.rb /path/to/images

require './src/config/initialize'
require './src/lib/image_iterator'
require './src/lib/readers/caching_decorator'
require './src/lib/readers/chain'
require './src/lib/readers/image_props'
require './src/lib/readers/phash'

# TODO: add argument to clear index
path = ARGV[0] || raise('Invalid directory')

# TODO: Add program argument for reader strategy
reader = Readers::CachingDecorator.new(
  Readers::Chain.new(
    [
      Readers::PHash.new,
      Readers::ImageProps.new
    ]
  )
)

# TODO: Add program argument for subdirectories
ii = ImageIterator.new(path, subdirectories: true)

ii.each_file do |file_name|
  debug(file_name)
  reader.read(file_name)
end
