class Node
  include Comparable

  DEFAULT_COMPARATOR = Proc.new { |a, b| a <=> b }

  attr_reader :object, :comparator
  attr_accessor :next

  def initialize(object, comparator)
    @object = object
    @comparator = comparator || DEFAULT_COMPARATOR
    @next = nil
  end

  def <=>(other)
    comparator.call(object, other.object)
  end
end
