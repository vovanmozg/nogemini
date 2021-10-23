require './src/lib/image_reader'

module Readers
  class ImageProps
    def read(fname)
      ImageReader.read(fname).merge('fname' => fname)
    end
  end
end