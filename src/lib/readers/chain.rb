module Readers
  class Chain
    def initialize(readers)
      @readers = readers
    end

    def read(fname)
      @readers.reduce({}) do |props, reader|
        data = reader.read(fname) || {}
        props.merge(data)
      end
    end
  end
end
