require_relative 'p04_linked_list'

class HashMap

  include Enumerable

  attr_accessor :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { LinkedList.new }
    @count = 0
    @insertion_order = Array.new() #update when #get and #delete keys
  end

  def include?(key)
    store[bucket(key)].include?(key)
  end

  def set(key, val)
    case store[bucket(key)].include?(key)
    when true
      store[bucket(key)].update(key, val)

      insertion_order.delete(key)
      insertion_order.push(key)
    when false
      store[bucket(key)].append(key, val)

      insertion_order.push(key)
      self.count += 1
    end

    resize! if self.count >= num_buckets
  end

  def get(key)
    store[bucket(key)].get(key)
  end

  def delete(key)
    case store[bucket(key)].include?(key)
    when true
      store[bucket(key)].remove(key)

      insertion_order.delete(key)
      self.count -= 1
    end
  end

  #original each method
  # def each
  #   store.each do |linked_list|
  #     linked_list.each do |node|
  #       yield(node.key, node.val)
  #     end
  #   end
  # end

  #new each method preserving insertion order
  def each
    insertion_order.each do |key|
      val = self.get(key)
      yield(key, val)
    end
  end

  # uncomment when you have Enumerable included
  def to_s
    pairs = inject([]) do |strs, (k, v)|
      strs << "#{k.to_s} => #{v.to_s}"
    end
    "{\n" + pairs.join(",\n") + "\n}"
  end

  alias_method :[], :get
  alias_method :[]=, :set

  private

  attr_accessor :store, :insertion_order

  def num_buckets
    @store.length
  end

  def resize!
    store_temp = Array.new(num_buckets * 2) { LinkedList.new }

    self.each do |key, val|
      list_idx = key.hash % (num_buckets * 2)
      store_temp[list_idx].append(key, val)
    end

    self.store = store_temp
  end

  def bucket(key)
    # optional but useful; return the bucket corresponding to `key`
    key.hash % num_buckets
  end
end
