require_relative 'p05_hash_map'
require_relative 'p04_linked_list'

class LRUCache
  attr_reader :count, :max, :prc
  def initialize(max, prc)
    @map = HashMap.new
    @store = LinkedList.new
    @max = max
    @prc = prc
  end

  def count
    @map.count
  end

  def get(key)
    if @map.include?(key)
      update_node!(@map.get(key))
    else
      calc!(key)
    end
    @store.get(key)
  end

  def to_s
    'Map: ' + @map.to_s + '\n' + 'Store: ' + @store.to_s
  end

  private

  def calc!(key)
    # suggested helper method; insert an (un-cached) key
    eject! if count >= max
    val = prc.call(key)
    @store.append(key, val)
    @map.set(key, @store.last)
  end

  def update_node!(node)
    # suggested helper method; move a node to the end of the list
    @store.remove(node.key)
    @store.append(node.key, node.val)
    @map.set(node.key, @store.last)
  end

  def eject!
    node_key = @store.first.key
    @store.first.remove
    @map.delete(node_key)
  end
end
