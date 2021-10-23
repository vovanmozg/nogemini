require './src/lib/ngphash'

class PHashComparator
  def self.cmp(f1, f2)

    p '--------------'
    p f1['phash']
    p f2['phash']
    distance = NGPHash.distance(
      f1['phash'],
      f2['phash']
    )
    {
      similar: distance == 2,
      distance: distance
    }
  end
end
