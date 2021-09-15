#!/usr/bin/env ruby

require 'phashion'
require "mini_magick"
require 'awesome_print'
require './lib/image_iterator'
require './lib/shash'

DB = './data.pstore'

class ImageReader
	def self.read(file)
		image = MiniMagick::Image.open(file)
		image.data
	end
end

class Kuku

	def initialize
		@hashes = []

		@compared = Hash.new({})

	end

	def already_compared?(file1, file2)
		@compared[file1][file2] != nil
	end

	def read_all(path)
		ii = ImageIterator.new(path)
		#files = Dir.glob("#{path}/*").select { |file| file =~ /(jpeg|jpg|png)$/i }


		#ps = PStore.new("data.pstore")

		sh = {} #SHash.new(DB)
		h = sh.to_h

		ii.each_file do |file|
			print '.'
			afile = File.absolute_path(file)
			
			shafile = h[afile]
			if shafile.nil?
				begin
					properties = ImageReader.read(file)
					properties[:phash] = Phashion.image_hash_for(file)
					sh[afile] = properties
				rescue MiniMagick::Invalid
				end
				#ap properties
			else
				#ap shafile
			end

		end
		print "\n"

		#p sh.to_h
	end


	def run
		path='./files'
		path='/home/**/*'
		path = '/Users/vovanmozg/Downloads/nogemini/test/1'

		read_all(path)
		return


		# files = Dir.glob("#{path}/*").select { |file| file =~ /(jpeg|jpg|png)$/i }

		# files.each do |file1|
		# 	files.each do |file2|
		# 		if already_compared?(file1, file2)
		# 			next
		# 		end
		# 		if file1 == file2
		# 			next
		# 		end
		# 		img1 = Phashion::Image.new(file1)
		# 		img2 = Phashion::Image.new(file2)
		# 		@compared[file1][file2] = img1.distance_from(img2)
		# 		@compared[file2][file1] = img1.distance_from(img2)
		# 		p "#{img1.distance_from(img2)} #{file1} #{file2}"

		# 	end
		# end

		# p '----------'
		# p @compared
	end
end

kuku = Kuku.new
kuku.run



