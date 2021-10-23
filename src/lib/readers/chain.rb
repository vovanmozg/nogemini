module Readers
  class Chain
    def initialize(readers)
      @readers = readers
    end

    def read(fname)
      @readers.reduce({}) do |props, reader|
        props.merge(reader.read(fname))
      end
    end
  end
end
