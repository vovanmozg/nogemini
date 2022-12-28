require './src/lib/ngphash'

class PHashComparator
  def self.cmp(f1, f2)

    raise ArgumentError if f1['phash'].nil?
    raise ArgumentError if f2['phash'].nil?

    #p "#{f1['phash']} #{f2['phash']}"

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
