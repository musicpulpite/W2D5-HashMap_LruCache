require 'byebug'

class Node
  attr_accessor :key, :val, :next, :prev

  def initialize(key = nil, val = nil)
    @key = key
    @val = val
    @next = nil
    @prev = nil
  end

  def to_s
    "#{@key}: #{@val}"
  end

  def remove
    # optional but useful, connects previous link to next link
    # and removes self from list.

    self.prev.next = self.next
    self.next.prev = self.prev
    self.next, self.prev = nil, nil
  end
end

class LinkedList

  include Enumerable

  attr_accessor :head, :tail

  def initialize
    @head = Node.new
    @tail = Node.new
    @head.next = @tail
    @tail.prev = @head
  end

  def [](i)
    each_with_index { |link, j| return link if i == j }
    nil
  end

  def first
    self.head.next unless empty?
  end

  def last
    self.tail.prev unless empty?
  end

  def empty?
    self.head.next == self.tail
  end

  def get(key)
    self.each {|node| return node.val if node.key == key}
    nil
  end

  def include?(key)
    return false if self.empty?
    self.each do |node|
      return true if node.key == key
     end
    false
  end

  def append(key, val)
    node = Node.new(key, val)

    if empty?
      self.head.next = node
      self.tail.prev = node

      node.prev, node.next = self.head, self.tail
    else
      self.last.next, node.prev = node, self.last
      self.tail.prev, node.next = node, self.tail
    end
  end

  def update(key, val)
    # raise "key does not exist in linked list" unless self.include?(key)

    self.each do |node|
      if node.key == key
        node.val = val
        return
      end
    end
  end

  def remove(key)
    # raise "key does not exist in linked list" unless self.include?(key)

    self.each do |node|
      if node.key == key
        node.remove
        return
      end
    end
  end

  def each
    node = self.first
    return if node.nil?

    until node == self.tail
      yield(node)
      node = node.next
    end
  end

  #uncomment when you have `each` working and `Enumerable` included
  def to_s
    inject([]) { |acc, link| acc << "[#{link.key}, #{link.val}]" }.join(", ")
  end
end
