class MaxIntSet


  def initialize(max)
    @max = max
    @store = Array.new(max + 1, false)
  end

  def insert(num)
    is_valid?(num)
    store[num] = true #!!!!!
  end

  def remove(num)
    is_valid?(num)
    store[num] = false
  end

  def include?(num)
    is_valid?(num)
    store[num]
  end

  private

  attr_reader :max
  attr_accessor :store

  def is_valid?(num)
    raise "Out of bounds" if num > max || num < 0
  end

  def validate!(num)
  end
end


class IntSet
  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
  end

  def insert(num)
    return if include?(num)
    bucket_idx = num % num_buckets
    store[bucket_idx] << num
  end

  def remove(num)
    bucket_idx = num % num_buckets
    store[bucket_idx].delete(num)
  end

  def include?(num)
    bucket_idx = num % num_buckets
    store[bucket_idx].include?(num)
  end

  private

  attr_accessor :store

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
  end

  def num_buckets
    @store.length
  end
end

class ResizingIntSet
  attr_accessor :count

  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(num)
    return if include?(num)

    bucket_idx = num % num_buckets
    store[bucket_idx] << num

    self.count += 1

    resize! if count >= num_buckets
  end

  def remove(num)
    return unless include?(num)

    bucket_idx = num % num_buckets
    store[bucket_idx].delete(num)

    self.count -= 1
  end

  def include?(num)
    bucket_idx = num % num_buckets
    store[bucket_idx].include?(num)
  end

  private

  attr_accessor :store

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
  end

  def num_buckets
    store.length
  end

  def resize!

    store_temp = Array.new(num_buckets * 2) {Array.new}

    store.each do |bucket|
      bucket.each do |el|
        bucket_idx = el % (num_buckets * 2)

        store_temp[bucket_idx] << el
      end
    end

    self.store = store_temp
  end
end
