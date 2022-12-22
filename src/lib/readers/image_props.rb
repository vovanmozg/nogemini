require './src/lib/image_reader'

module Readers
  class ImageProps
    def read(fname)
      ImageReader.read(fname).merge('fname' => fname)
    rescue MiniMagick::Error, MiniMagick::Invalid => error
      debug("#{fname}: #{error}")
      nil
    end
  end
end
