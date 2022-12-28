# frozen_string_literal: true

# Using:
# ruby src/reorgan.rb -f
require './src/config/initialize'
require './src/lib/reorganizer'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ruby reorgan.rb [options]"

  opts.on("-f", "--file=FILE", "File with dups information") do |v|
    options[:file] = v
  end
end.parse!

options[:file].nil? && raise('Invalid file')

stat = Reorganizer.new.call(options[:file])
info(stat)
