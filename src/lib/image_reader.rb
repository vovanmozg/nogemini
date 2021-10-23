require 'mini_magick'

class ImageReader
  def self.read(file_name)
    image = MiniMagick::Image.open(file_name)
    image.data
  end
end
