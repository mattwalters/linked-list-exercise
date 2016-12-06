class Node
  include Comparable

  attr_reader :object
  attr_accessor :next

  def initialize(object)
    @object = object
    @next = nil
  end

  def <=>(other)
    object <=> other.object
  end
end
