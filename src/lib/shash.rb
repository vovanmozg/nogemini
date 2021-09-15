require "pstore"

class SHash
  include Enumerable

  def initialize(file)
    @db = PStore.new(file)
  end

  def [](key)
    @db.transaction do
      @db[key]
    end
  end

  def []=(key, value)
    @db.transaction do
      @db[key] = value
    end
  end

  def to_h
    @db.transaction do
      @db.roots.map { |key| [key, @db[key]] }.to_h
    end
  end

  def each(&block)
    to_h.each(&block)
  end
end
