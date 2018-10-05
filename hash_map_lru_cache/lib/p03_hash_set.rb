class HashSet
  attr_accessor :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(key)
    return if include?(key)

    self[key.hash] << key
    self.count += 1

    resize! if count >= num_buckets
  end

  def include?(key)
    self[key.hash].include?(key)
  end

  def remove(key)
    return unless include?(key)

    self[key.hash].delete(key)
    self.count -= 1
  end

  private

  attr_accessor :store

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
    store[num % num_buckets]
  end

  def num_buckets
    @store.length
  end

  def resize!

    store_temp = Array.new(num_buckets * 2) {Array.new}

    store.each do |bucket|
      bucket.each do |el|
        bucket_idx = el.hash % (num_buckets * 2)

        store_temp[bucket_idx] << el
      end
    end

    self.store = store_temp
  end
end
