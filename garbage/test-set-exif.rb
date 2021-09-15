#require 'rubygems'
#require 'bundler/setup'
require 'mini_exiftool'

path = '/Users/vovanmozg/Downloads/nogemini/test/1/20180426 191858.jpg'


100.times do
  photo = MiniExiftool.new path
  puts photo.title
end
