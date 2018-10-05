class Fixnum
  # Fixnum#hash already implemented for you
end

class Array
  def hash
    sum = 0
    self.each_with_index {|el, idx| sum += (el * (idx + 1))}
    hash = sum.hash
  end
end

class String
  def hash
    char_values_array = self.chars.map {|char| char.unpack("C*")[0]}
    hash = char_values_array.hash
  end
end

class Hash
  # This returns 0 because rspec will break if it returns nil
  # Make sure to implement an actual Hash#hash method
  def hash
    0
  end
end
