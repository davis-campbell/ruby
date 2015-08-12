class Node
  attr_accessor :parent
  attr_reader :value, :left_child, :right_child

  def initialize(value)
    @value = value
  end

  def children
    begin
      return [@left_child.value, @right_child.value]
    rescue
      return 'None' if @left_child.nil? && @right_child.nil?
      return @left_child.nil? ? @right_child.value : @left_child.value
    end
  end

  def relationships
    puts "Value: #{self.value} | Parent: #{self.parent.nil? ? 'None' : self.parent.value} | Children: #{self.children}"
  end

  def left_child=(n)
    @left_child = n
    begin
      @left_child.parent = self
    rescue
      @left_child = nil
    end
  end

  def right_child=(n)
    @right_child = n
    begin
      @right_child.parent = self
    rescue
      @right_child = nil
    end
  end

  def has_parent?
    return true if self.parent.nil? == false
  end


end

def midpoint(ary)
  return ary[ary.length/2]
end

def branches(ary)
  return ary[0..ary.length/2-1], ary[ary.length/2+1..-1]
end


# Recursive method that builds a binary tree from a sorted array
def build_tree_sorted(ary)
  return Node.new(ary[0]) if ary.length == 1
  return nil if ary.empty?
  root = Node.new(midpoint(ary))
  branch1, branch2 = branches(ary)
  root.left_child = build_tree(branch1)
  root.right_child = build_tree(branch2)
  return root
end

# Iterative method that builds a binary tree.
# Accepts any array, whether sorted or not.
def build_tree(ary)
  tree = ary.map do |value| # Creates an array of nodes
    Node.new(value)
  end
  tree[1..-1].each do |node|
    root = tree[0]
    until node.has_parent?
      if root.value > node.value
        if root.left_child.nil?
          root.left_child = node
        else
          root = root.left_child
        end
      elsif root.value <= node.value
        if root.right_child.nil?
          root.right_child = node
        else
          root = root.right_child
        end
      end
    end
  end
  return tree
end

# Starts at the root, gives priority to left children.
def bfs(tree, value)
  found = false
  root_queue = [tree[0]]
  return tree[0].relationships if tree[0].value == value
  until root_queue.empty?
    root = root_queue[0]
    unless root.left_child.nil?
      return root.left_child.relationships if root.left_child.value == value
      root_queue.push(root.left_child)
    end
    unless root.right_child.nil?
      return root.right_child.relationships if root.right_child.value == value
      root_queue.push(root.right_child)
    end
    root_queue.shift
  end
  return nil
end

# Starts at the root, gives priority to left children.
def dfs(tree, value)
  visited = []
  root_stack = [tree[0]]
  return tree[0].relationships if tree[0].value == value
  until root_stack.empty?
    root = root_stack[-1]
    visited.push(root)
    unless root.left_child.nil? || visited.include?(root.left_child)
      return root.left_child.relationships if root.left_child.value == value
      root_stack.push(root.left_child)
      next
    end
    unless root.right_child.nil? || visited.include?(root.right_child)
      return root.right_child.relationships if root.right_child.value == value
      root_stack.push(root.right_child)
      next
    end
    root_stack.pop
  end
  return nil
end

# Searchs root and all of its descendants for value recursively.
def dfs_rec(root, value)
  return root.relationships if root.value == value
  unless root.left_child.nil?
    dfs_rec(root.left_child, value)
  end
  unless root.right_child.nil?
    dfs_rec(root.right_child, value)
  end
  return nil
end
