require 'phashion'
img1 = Phashion::Image.new('/Users/vovanmozg/Downloads/nogemini/test/1/20180426 191858.jpg')
img2 = Phashion::Image.new('/Users/vovanmozg/Downloads/nogemini/test/2/20180426 191858.jpg')

p img1.duplicate?(img2)