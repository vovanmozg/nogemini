require 'phashion'

module Readers
  class PHash
    def read(fname)
      { 'phash' => Phashion.image_hash_for(fname) }
    end
  end
end