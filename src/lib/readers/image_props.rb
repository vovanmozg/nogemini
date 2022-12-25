require './src/lib/image_reader'

module Readers
  class ImageProps
    def read(fname)
      data = ImageReader.read(fname).merge('fname' => fname)
      remove_useless_attributes(data)
    rescue MiniMagick::Error, MiniMagick::Invalid => error
      error("#{fname}: #{error}")
      nil
    end

    def remove_useless_attributes(data)
      data['properties'].delete('exif:MakerNote')
      data['properties'].delete('exif:PrintImageMatching')
      data
    end
  end
end
