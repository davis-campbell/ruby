class Game
  def initialize
    print "Welcome to chess! Enter name of Player 1: "
    @player1 = Player.new(1, gets.chomp)
    print "Enter name of Player 2: "
    @player2 = Player.new(2, gets.chomp)
    @board = Board.new
    @turns = 0
    @active = "White"
    puts "#{@player1} will be white, and #{@player2} will be black."
    play
  end

  def play
    until gg?
      @board.display
      player = @active == "White" ? @player1 : @player2
      puts "#{player}, it's your turn."
      print "Enter the location of the piece you want to move (e.g. G4): "
      selected = @board.locate(gets.chomp.capitalize)
      puts selected[1]
      @active = @active == "White" ? "Black" : "White"
    end
  end

  def gg?

  end
  class Board < Array

    def initialize
      positions = {
        :Rook   => [0, 7],
        :Knight => [1, 6],
        :Bishop => [2, 5],
        :Queen  => [3],
        :King   => [4],
      }
      8.times do |y|
        row = []
        8.times { |x| row.push(Space.new(x, y)) }
        self.push(row)
      end
      self.each do |row|
        row_index = self.index(row)
        row.each do |space|
          space_index = row.index(space)
          space.color = (row_index + space_index).even? ? "White" : "Black"
        end
      end
      positions.each do |piece, places|
        places.each do |space|
          self[0][space].occupied = Object.const_get("Game::#{piece}").new("Black", self[0][space])
          self[7][space].occupied = Object.const_get("Game::#{piece}").new("White", self[7][space])
        end
      end
      self[1].each { |space| space.occupied = Game::Pawn.new("Black", space) }
      self[6].each { |space| space.occupied = Game::Pawn.new("White", space) }
    end

    def display
      letters = "     A    B    C    D    E    F    G    H"
      line = '  +----+----+----+----+----+----+----+----+'
      puts letters
      8.times do |x|
        puts line
        8.times do |y|
          row = (8 - x).to_s
          print "#{y == 0 ? row + ' ' : ''}| #{self[x][y].occupied} "
        end
        print "| #{8 - x}\r\n"
      end
      puts line
      puts letters
    end

    def locate(space)
      letters = ['A','B','C','D','E','F','G','H']
      x = letters.index(space[0])
      y = 8 - space[1].to_i
      piece = "#{self[y][x].occupied.class}"
      unless piece == "String"
        piece = 'a ' + piece.split('::')[1]
      else
        piece = 'nothing'
      end
      return [self[y][x], "There is #{piece} on that space."]
    end

    class Space
      attr_accessor :color, :occupied

      def initialize(x, y)
        @letters = ['A','B','C','D','E','F','G','H']
        @color = nil
        @occupied = '  '
        @location = [x,y]
      end
      def to_s
        letter = @letters[@location[0]]
        number = 8 - @location[1]
        return letter + number.to_s
      end
    end
  end
  class Piece
    attr_accessor :id, :position
    attr_reader :color

    def initialize(color, position)
      @color = color
      @position = position
    end

    def to_s
      self.id
    end

    def move

    end

    def find
      return @position.to_s
    end
  end
  class Pawn < Piece

    def initialize(color, position)
      super
      self.id = color == "Black" ? "*P" : " P"
      @moved = false
    end

    def moved?
      return @moved
    end


    def find
      super
    end
  end
  class Rook < Piece
    def initialize(color, position)
      super
      self.id = color == "Black" ? "*R" : " R"
    end
    def find
      super
    end
  end
  class Knight < Piece
    def initialize(color, position)
      super
      self.id = color == "Black" ? "*N" : " N"
    end
    def find
      super
    end
  end
  class Bishop < Piece
    def initialize(color, position)
      super
      self.id = color == "Black" ? "*B" : " B"
    end
    def find
      super
    end
  end
  class King < Piece
    def initialize(color, position)
      super
      self.id = color == "Black" ? "*K" : " K"
    end
    def find
      super
    end
  end
  class Queen < Piece
    def initialize(color, position)
      super
      self.id = color == "Black" ? "*Q" : " Q"
    end
    def find
      super
    end
  end
  class Player
    def initialize(number, name)
      @name = name
      @color = number == 1 ? "White" : "Black"
    end
    def to_s
      @name
    end
  end
end
