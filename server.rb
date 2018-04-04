require 'phashion'


files = Dir.glob("/Users/vovanmozg/Downloads/foto/**/*").select { |file| file =~ /(jpeg|jpg|png)$/i }
files.each do |file1|
	files.each do |file2|
		next if file1 == file2
		img1 = Phashion::Image.new(file1)
		img2 = Phashion::Image.new(file2)
		p img1.distance_from(img2)
	end	
end


