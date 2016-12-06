class List
  include Enumerable

  def initialize(options={})
    @options = options
    @size = 0
  end

  # add object to list based on list type
  def add(object)
    self.size += 1
    if maintain_sort_order?
      sorted_insert(object)
    else
      append(object)
    end
  end

  # enumerable mixin method
  def each
    if block_given?
      current_node = head_node
      while current_node
        yield current_node.object
        current_node = current_node.next
      end
    end
    self
  end

  # returns all elements in list
  def elements
    each.to_a
  end

  # returns true if the list is empty, false otherwise
  def empty?
    !head_node
  end

  # returns length of list
  def length
    size
  end

  # returns true if object is a member of the list, false otherwise
  def member?(object)
    each { |obj| return true if object == obj }
    false
  end

  # returns and removes the first element of the list; or nil if the list is empty
  def pop
    return nil if empty?
    popped_node = head_node
    self.head_node = head_node.next
    self.size -= 1
    popped_node.object
  end

  private

  attr_reader :options
  attr_accessor :head_node, :size

  def maintain_sort_order?
    sort_option = options[:sorted]
    raise ArgumentError(sort_option) unless [ 0, 1, nil ].member?(sort_option)
    sort_option == 1
  end

  def sorted_insert(object)
    additional_node = Node.new(object)
    if empty?
      self.head_node = additional_node

    elsif additional_node < head_node
      existing_node = head_node
      self.head_node = additional_node
      head_node.next = existing_node

    else
      current_node = head_node

      while current_node.next && current_node.next < additional_node
        current_node = current_node.next
      end
      existing_node = current_node.next
      current_node.next = additional_node
      additional_node.next = existing_node

    end
    additional_node
  end

  def append(object)
    additional_node = Node.new(object)
    if empty?
      self.head_node = additional_node
    else
      current_node = head_node
      while current_node.next
        current_node = current_node.next
      end
      current_node.next = additional_node
    end
    additional_node
  end
end
