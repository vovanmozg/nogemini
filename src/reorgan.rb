# frozen_string_literal: true

# Using:
# ruby src/reorgan.rb -f
require './src/config/initialize'
require './src/lib/reorganizer'

options = {
  mode: :bash,
}

OptionParser.new do |opts|
  opts.banner = "Usage: ruby reorgan.rb [options]"

  opts.on("-f", "--file=FILE", "File with dups information") do |v|
    options[:file] = v
  end

  # -d NOT SUPPORTED
  opts.on("-d", "--destination=DIR", "ROOT DIR for moving images") do |v|
    options[:destination] = v
  end

  opts.on("-m", "--mode=MODE", "Moving mode") do |v|
    options[:mode] = v.to_sym
  end
end.parse!

options[:file].nil? && raise('Invalid file')

stat = Reorganizer.new.call(**options)
info(stat)
