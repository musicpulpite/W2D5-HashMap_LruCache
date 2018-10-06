class StaticArray
  def initialize(capacity)
    @store = Array.new(capacity)
  end

  def [](i)
    validate!(i)
    @store[i]
  end

  def []=(i, val)
    validate!(i)
    @store[i] = val
  end

  def length
    @store.length
  end

  private

  def validate!(i)
    raise "Overflow error" unless i.between?(0, @store.length - 1)
  end
end

class DynamicArray
  attr_reader :count

  include Enumerable

  def initialize(capacity = 8)
    @store = StaticArray.new(capacity)
    @count = 0
  end

  def [](i)
    begin
      @store[i]
    rescue
      nil
    end
  end

  def []=(i, val)
    begin
      @store[i] = val
    rescue
      resize!
    end
  end

  def capacity
    @store.length
  end

  def include?(val)
    self.each {|el| return true if el == val}
    false
  end

  def push(val)
    begin
      self[count] = val
    rescue
      resize!
    ensure
      self[count] = val
      @count += 1
    end
  end

  def unshift(val)
    resize! if count == capacity

    i = count - 1
    while i >= 0
      self[i + 1] = self[i]
      self[i] = nil
      i -= 1
    end

    @count += 1
    self[0] = val
  end

  def pop
    return nil if count == 0

    last_val = self.last
    self[count - 1] = nil
    @count -= 1

    last_val
  end

  def shift
    first_val = self.first
    self[0] = nil

    i = 1
    while i < count
      self[i - 1] = self[i]
      self[i] = nil
      i += 1
    end

    @count -= 1
    first_val
  end

  def first
    self[0]
  end

  def last
    self[count - 1]
  end

  def each
    i = 0

    #If the underlying array isn't full (count < capacity)
    #then we don't want to pass the nil values at the end to the block
    while i < count
      el = self[i]
      next if el.nil?

      yield(el)
    end

    #@store[0...count] #each implicitly returns self (i.e. the underlying array) [note: not sure if range indexing will work]
  end

  def to_s
    "[" + inject([]) { |acc, el| acc << el }.join(", ") + "]"
  end

  def ==(other)
    return false unless [Array, DynamicArray].include?(other.class)
    # ...

    self.each_with_index {|el, idx| return false unless other[idx] == el}
    true
  end

  alias_method :<<, :push
  [:length, :size].each { |method| alias_method method, :count }

  private

  #This would be a good idea, but nevermind:
  #I'm changing resize so that rather than just doubling the
  #capacity of the array (like hash resize) it only expands enough
  #to accamodate the new val trying to be inserted.

  def resize!
    store_temp = StaticArray.new(capacity * 2)

    self.each_with_index do |el, i|
      store_temp[i] = el
    end

    @store = store_temp
  end
end
