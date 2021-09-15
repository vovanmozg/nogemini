require 'phashion'

class Kuku
	def initialize
		@compared = Hash.new({})
	end

	def already_compared?(file1, file2)
		@compared[file1][file2] != nil
	end

	def run
		path='/Users/vovanmozg/Downloads/foto/test/'

		files = Dir.glob("#{path}/*").select { |file| file =~ /(jpeg|jpg|png)$/i }

		files.each do |file1|
			files.each do |file2|
				if already_compared?(file1, file2)
					next
				end
				if file1 == file2
					next
				end
				img1 = Phashion::Image.new(file1)
				img2 = Phashion::Image.new(file2)
				@compared[file1][file2] = img1.distance_from(img2)
				@compared[file2][file1] = img1.distance_from(img2)

			end
		end

		p '----------'
		p @compared
	end
end

kuku = Kuku.new
kuku.run


