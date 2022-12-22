require 'phashion'

module Readers
  class PHash
    def read(fname)
      { 'phash' => Phashion.image_hash_for(fname) }
    rescue RuntimeError => error
      debug("#{fname}: #{error}")
      nil
    end
  end
end
