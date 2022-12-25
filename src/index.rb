# frozen_string_literal: true

# Calculates phash for input files and cache result to _info.txt in the
# directory where the files placed.
# Using example
#  ruby index.rb /path/to/images

require './src/config/initialize'
require './src/lib/image_iterator'
require './src/lib/readers/caching_decorator'
require './src/lib/readers/chain'
require './src/lib/readers/image_props'
require './src/lib/readers/phash'

# TODO: Add argument to clear index
# TODO: Add argument for logger engine and level
path = ARGV[0] || raise('Invalid directory')

# TODO: Add program argument for reader strategy
reader = Readers::CachingDecorator.new(
  Readers::Chain.new(
    [
      Readers::ImageProps.new,
      Readers::PHash.new
    ]
  )
)

# TODO: Add program argument for subdirectories

#ii = CachingIterator.new(ImageIterator.new(path, subdirectories: true))
ii = ImageIterator.new(path, subdirectories: true)

debug('================= START =================='.red)
ii.each_file do |file_name|
  info(file_name.red)
  reader.read(file_name)
end

debug('waiting threads...')
CacheProviders::Files2::InfoFileAccessor.threads.each { |thr| thr.join }
