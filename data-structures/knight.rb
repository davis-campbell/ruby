$moves = [[1,2],[-1,2],[-1,-2],[1,-2],[2,1],[-2,1],[-2,-1],[2,-1]]

class Square

  attr_reader :vert, :horiz, :children
  attr_accessor :parent

  def initialize(vert, horiz)
    @vert = vert
    @horiz = horiz
  end

  def gen_children
    moves = $moves.map do |move|
      Square.new(self.vert + move[0], self.horiz + move[1])
    end
    @children = moves.select { |square| square.on_board? }
    @children.each do |child|
      child.parent = self
    end
  end

  def on_board?
    if vert < 1 || vert > 8 || horiz < 1 || horiz > 8
      return false
    else
      return true
    end
  end

  def ancestry # Returns all ancestors of a square, starting with the parent.
    ary = [self]
    return ary if self.parent.nil?
    ary << self.parent.ancestry
  end

end

def knight_moves(c1, c2)
  if c1 == c2
    return "You're already there! 0 moves."
  end
  start = Square.new(c1[0], c1[1])
  queue = []
  found = false
  search_moves = lambda do |square|
    if [square.vert, square.horiz] == c2
      ancestry = square.ancestry.flatten.reverse
      puts "It will take you #{ancestry.length - 1} move(s) to get from #{c1} to #{c2}."
      ancestry.each do |sq|
        p [sq.vert,sq.horiz]
      end
      found = true
      return
    end
    queue.push(square)
    #queue.each {|sq| p [sq.vert,sq.horiz]}
  end
  queue.push(start)
  until found do
    #queue.each {|sq| p [sq.vert,sq.horiz]}
    node = queue.shift
    #queue.each {|sq| p [sq.vert,sq.horiz]}
    node.gen_children
    node.children.each(&search_moves)
  end
  #queue.each {|sq| p [sq.vert,sq.horiz]}
end
