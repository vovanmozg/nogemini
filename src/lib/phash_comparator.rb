require './src/lib/ngphash'

class PHashComparator
  def self.cmp(f1, f2)
    distance = NGPHash.distance(
      NGPHash.calculate(f1),
      NGPHash.calculate(f2)
    )
    {
      result: distance == 2,
      distance: distance
    }
  end
end
