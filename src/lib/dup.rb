require 'phashion'

class Dup
  def self.duplicate_files?(file1, file2)
    img1 = Phashion::Image.new(file1)
    img2 = Phashion::Image.new(file2)
    img1.duplicate?(img2)
  end

  def self.distance(file1, file2)
    phash1 = Phashion.image_hash_for(file1)
    phash2 = Phashion.image_hash_for(file2)

    Phashion.hamming_distance(phash1, phash2)
  end

  def self.distance_phashes(phash1, phash2)
    Phashion.hamming_distance(phash1, phash2)
  end
end
