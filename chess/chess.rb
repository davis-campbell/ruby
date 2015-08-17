class Game
  class InCheck < StandardError
  end
  def initialize
    print "Welcome to chess! Enter name of Player 1: "
    @player1 = Player.new(1, gets.chomp)
    print "Enter name of Player 2: "
    @player2 = Player.new(2, gets.chomp)
    @board = Board.new
    @board.setup
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
      king = @board.pieces.select do |piece|
        piece.class == Game::King && piece.color == player.color
      end
      puts "You are in check!" if king[0].is_in_check?
      begin
        begin
          print "Enter the location of the piece you want to move (e.g. G4): "
          selected = @board.locate(gets.chomp.capitalize, player.color)
          puts selected[1]
          piece = selected[0].occupied
        rescue ArgumentError || TypeError
          puts "Pick a space with one of your pieces on it."
          retry
        end
        puts "Where would you like to move it? Enter a location or 'X' to choose a different piece."
        begin
          piece.move(gets.chomp.capitalize)
        rescue ArgumentError || TypeError
          puts "That's not a valid move; try again or enter 'X'"
          retry
        rescue InCheck
          puts "If you do that, you will be/remain in check!"
          retry
        end
      rescue RuntimeError
        retry
      end
      @active = @active == "White" ? "Black" : "White"
    end
    @board.display
    puts "Checkmate! #{player} wins!"
  end

  def gg?
    kings = @board.pieces.select { |piece| piece.class == Game::King }
    kings.any?(&:checkmate?)
  end
  class Board < Array
    attr_accessor :pieces
    def initialize
      @pieces = []
      8.times do |y|
        row = []
        8.times { |x| row.push(Space.new(x, y)) }
        self.push(row)
      end
    end

    def setup

      positions = {
        :Rook   => [0, 7],
        :Knight => [1, 6],
        :Bishop => [2, 5],
        :Queen  => [3],
        :King   => [4],
      }
      positions.each do |piece, places|
        places.each do |space|
          self[0][space].occupied = Object.const_get("Game::#{piece}").new("Black", self[0][space], self)
          self[7][space].occupied = Object.const_get("Game::#{piece}").new("White", self[7][space], self)
        end
      end
      self[1].each { |space| space.occupied = Game::Pawn.new("Black", space, self) }
      self[6].each { |space| space.occupied = Game::Pawn.new("White", space, self) }
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

    def locate(space, color)
      letters = ['A','B','C','D','E','F','G','H']
      x = letters.index(space[0])
      y = 8 - space[1].to_i
      obj = self[y][x].occupied
      piece = "#{obj.class}"
      if piece == "String" || obj.color != color
        raise ArgumentError
      else
        piece = 'a ' + piece.split('::')[1]
      end
      return [self[y][x], "There is #{piece} on that space."]
    end

    def space(space)
      letters = ['A','B','C','D','E','F','G','H']
      x = letters.index(space[0])
      y = 8 - space[1].to_i
      self[y][x]
    end

    def contains?(space)
      begin
        self.space(space)
        return true
      rescue
        return false
      end
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
      def id
        return self.to_s
      end
    end
  end
  class Piece
    attr_accessor :id, :position
    attr_reader :color, :board

    def initialize(color, position, board)
      @color = color
      @position = position
      @board = board
      @board.pieces.push(self)
    end

    def to_s
      self.id
    end

    def move(location)
      raise RuntimeError if location == "X"
    end



    def find
      return @position.to_s
    end



  end
  class Pawn < Piece

    def initialize(color, position, board)
      super
      self.id = color == "Black" ? "*P" : " P"
      @moved = false
    end

    def moved?
      return @moved
    end

    def get_moves
      return [] if self.position.nil?
      letters = ('A'..'H').to_a
      moves = []
      white = self.color == "White" ? true : false
      if white
        unless moved?
          moves.push("#{self.find[0]}#{self.find[1].to_i + 2}")
        end
        moves.push("#{self.find[0]}#{self.find[1].to_i + 1}")
        moves.select! { |move| board.contains?(move) }
        moves.select! do |move|
          board.space(move).occupied == '  '
        end
        dmoves = []
        dmoves.push("#{letters[letters.index(self.find[0]) + 1]}#{self.find[1].to_i + 1}")
        dmoves.push("#{letters[letters.index(self.find[0]) - 1]}#{self.find[1].to_i + 1}")
        dmoves.select! { |move| board.contains?(move) }
        dmoves.select! do |move|
          board.space(move).occupied != '  ' && board.space(move).occupied.color != self.color
        end
        dmoves.each { |move| moves.push(move) }
      else
        unless moved?
          moves.push("#{self.find[0]}#{self.find[1].to_i - 2}")
        end
        moves.push("#{self.find[0]}#{self.find[1].to_i - 1}")
        moves.select! { |move| board.contains?(move) }
        moves.select! do |move|
          board.space(move).occupied == '  '
        end
        dmoves = []
        dmoves.push("#{letters[letters.index(self.find[0]) + 1]}#{self.find[1].to_i - 1}")
        dmoves.push("#{letters[letters.index(self.find[0]) - 1]}#{self.find[1].to_i - 1}")
        dmoves.select! { |move| board.contains?(move) }
        dmoves.select! do |move|
          board.space(move).occupied != '  ' && board.space(move).occupied.color != self.color
        end
        dmoves.each { |move| moves.push(move) }
      end
      return moves
    end


    def move(location)
      super
      moves = get_moves
      raise ArgumentError unless moves.include?(location)
      original_state = self
      old_piece = board.space(location).occupied
      @moved = true
      @position.occupied = '  '
      @position = board.space(location)
      board.pieces.delete(@position.occupied)
      @position.occupied = self
      king = @board.pieces.select do |piece|
        piece.class == Game::King && piece.color == self.color
      end
      if king[0].is_in_check?
        puts "You need to get out of check!"
        @moved = original_state.moved?
        @position = original_state.position
        board.space(location).occupied = old_piece
        board.pieces.push(old_piece) unless old_piece == '  '
        @position.occupied = self
        raise InCheck
      end
    end
    def try(location)
      out_of_check = true
      original_state = self.position
      old_piece = board.space(location).occupied
      @position.occupied = '  '
      @position = board.space(location)
      board.pieces.delete(@position.occupied)
      @position.occupied = self
      king = @board.pieces.select do |piece|
        piece.class == Game::King && piece.color == self.color
      end
      out_of_check = king[0].is_in_check? ? false : true
      @position = original_state
      board.space(location).occupied = old_piece
      board.pieces.push(old_piece) unless old_piece == '  '
      @position.occupied = self
      return out_of_check
    end

    def find
      super
    end
  end

  class Rook < Piece
    def initialize(color, position, board)
      super
      self.id = color == "Black" ? "*R" : " R"
    end
    def find
      super
    end
    def get_moves
      return [] if self.position.nil?
      x, y = self.find[0], self.find[1]
      letters = ('A'..'H').to_a
      horiz_moves = []
      letters.each { |letter| horiz_moves.push("#{letter}#{y}") }
      index = horiz_moves.index(self.find)
      left = horiz_moves[0..(index - 1)].reverse
      right = horiz_moves[(index + 1)..-1]
      vert_moves = []
      (1..8).to_a.each { |num| vert_moves.push("#{x}#{num}") }
      index = vert_moves.index(self.find)
      up = vert_moves[0..(index - 1)].reverse
      down = vert_moves[(index + 1)..-1]
      directions = [up,down,left,right]
      moves = []
      directions.each do |direction|
        blocked = false
        direction.each do |move|
          break if blocked
          in_way = board.space(move).occupied
          if in_way == '  '
            moves.push(move)
          elsif in_way.color != self.color
            moves.push(move)
            break
          else
            break
          end
        end
      end
      return moves
    end

    def move(location)
      super
      moves = get_moves
      raise ArgumentError unless moves.include?(location)
      original_state = self
      old_piece = board.space(location).occupied
      @position.occupied = '  '
      @position = board.space(location)
      board.pieces.delete(@position.occupied)
      @position.occupied = self
      king = @board.pieces.select do |piece|
        piece.class == Game::King && piece.color == self.color
      end
      if king[0].is_in_check?
        puts "You need to get out of check!"
        @position = original_state.position
        board.space(location).occupied = old_piece
        board.pieces.push(old_piece) unless old_piece == '  '
        @position.occupied = self
        raise InCheck
      end
    end
    def try(location)
      out_of_check = true
      original_state = self.position
      old_piece = board.space(location).occupied
      @position.occupied = '  '
      @position = board.space(location)
      board.pieces.delete(@position.occupied)
      @position.occupied = self
      king = @board.pieces.select do |piece|
        piece.class == Game::King && piece.color == self.color
      end
      out_of_check = king[0].is_in_check? ? false : true
      @position = original_state
      board.space(location).occupied = old_piece
      board.pieces.push(old_piece) unless old_piece == '  '
      @position.occupied = self
      return out_of_check
    end
  end

  class Knight < Piece
    def initialize(color, position, board)
      super
      self.id = color == "Black" ? "*N" : " N"
    end
    def find
      super
    end
    def get_moves
      return [] if self.position.nil?
      letters = ('A'..'H').to_a
      moves = [[1,2],[-1,2],[-1,-2],[1,-2],[2,1],[-2,1],[-2,-1],[2,-1]]
      moves.map! do |move|
        start = self.find
        finish = "#{letters[letters.index(start[0]) + move[0]]}#{start[1].to_i + move[1]}"
        finish
      end
      moves.select! { |move| board.contains?(move) }
      moves.select! do |move|
        in_way = board.space(move).occupied
        in_way == '  ' || in_way.color != self.color
      end
      return moves
    end

    def move(location)
      super
      moves = get_moves
      raise ArgumentError unless moves.include?(location)
      original_state = self
      old_piece = board.space(location).occupied
      @position.occupied = '  '
      @position = board.space(location)
      board.pieces.delete(@position.occupied)
      @position.occupied = self
      king = @board.pieces.select do |piece|
        piece.class == Game::King && piece.color == self.color
      end
      if king[0].is_in_check?
        puts "You need to get out of check!"
        @position = original_state.position
        board.space(location).occupied = old_piece
        board.pieces.push(old_piece) unless old_piece == '  '
        @position.occupied = self
        raise InCheck
      end
    end
    def try(location)
      out_of_check = true
      original_state = self.position
      old_piece = board.space(location).occupied
      @position.occupied = '  '
      @position = board.space(location)
      board.pieces.delete(@position.occupied)
      @position.occupied = self
      king = @board.pieces.select do |piece|
        piece.class == Game::King && piece.color == self.color
      end
      out_of_check = king[0].is_in_check? ? false : true
      @position = original_state
      board.space(location).occupied = old_piece
      board.pieces.push(old_piece) unless old_piece == '  '
      @position.occupied = self
      return out_of_check
    end
  end

  class Bishop < Piece
    def initialize(color, position, board)
      super
      self.id = color == "Black" ? "*B" : " B"
    end
    def find
      super
    end

    def get_moves
      return [] if self.position.nil?
      letters = ('A'..'H').to_a
      start = self.find
      directions = [[1,1],[-1,1],[-1,-1],[1,-1]]
      moves = []
      directions.each do |direction|
        blocked = false
        letter = letters.index(start[0])
        number = start[1].to_i
        until blocked
          letter += direction[0]
          number += direction[1]
          new_space = "#{letters[letter]}#{number}"
          break unless board.contains?(new_space)
          if board.space(new_space).occupied == '  '
            moves.push(new_space)
          elsif board.space(new_space).occupied.color != self.color
            moves.push(new_space)
            break
          else
            break
          end
        end
      end
      moves
    end

    def move(location)
      super
      moves = get_moves
      raise ArgumentError unless moves.include?(location)
      original_state = self
      old_piece = board.space(location).occupied
      @position.occupied = '  '
      @position = board.space(location)
      board.pieces.delete(@position.occupied)
      @position.occupied = self
      king = @board.pieces.select do |piece|
        piece.class == Game::King && piece.color == self.color
      end
      if king[0].is_in_check?
        puts "You need to get out of check!"
        @position = original_state.position
        board.space(location).occupied = old_piece
        board.pieces.push(old_piece) unless old_piece == '  '
        @position.occupied = self
        raise InCheck
      end
    end
    def try(location)
      out_of_check = true
      original_state = self.position
      old_piece = board.space(location).occupied
      @position.occupied = '  '
      @position = board.space(location)
      board.pieces.delete(@position.occupied)
      @position.occupied = self
      king = @board.pieces.select do |piece|
        piece.class == Game::King && piece.color == self.color
      end
      out_of_check = king[0].is_in_check? ? false : true
      @position = original_state
      board.space(location).occupied = old_piece
      board.pieces.push(old_piece) unless old_piece == '  '
      @position.occupied = self
      return out_of_check
    end

  end

  class King < Piece
    def initialize(color, position, board)
      super
      self.id = color == "Black" ? "*K" : " K"
    end
    def find
      super
    end

    def get_moves
      return [] if self.position.nil?
      letters = ('A'..'H').to_a
      start = self.find
      directions = [[1,1],[-1,1],[-1,-1],[1,-1],[1,0],[-1,0],[0,1],[0,-1]]
      moves = []
      directions.each do |direction|
        letter = letters.index(start[0])
        number = start[1].to_i
        letter += direction[0]
        number += direction[1]
        new_space = "#{letters[letter]}#{number}"
        next unless board.contains?(new_space)
        if board.space(new_space).occupied == '  '
          moves.push(new_space)
        elsif board.space(new_space).occupied.color != self.color
          moves.push(new_space)
        else
          next
        end
      end
      moves
    end

    def move(location)
      super
      moves = get_moves
      raise ArgumentError unless moves.include?(location)
      original_state = self
      old_piece = board.space(location).occupied
      @position.occupied = '  '
      @position = board.space(location)
      board.pieces.delete(@position.occupied)
      @position.occupied = self
      king = @board.pieces.select do |piece|
        piece.class == Game::King && piece.color == self.color
      end
      if king[0].is_in_check?
        puts "You need to get out of check!"
        @position = original_state.position
        board.space(location).occupied = old_piece
        board.pieces.push(old_piece) unless old_piece == '  '
        @position.occupied = self
        raise InCheck
      end
    end
    def try(location)
      out_of_check = true
      original_state = self.position
      old_piece = board.space(location).occupied
      @position.occupied = '  '
      @position = board.space(location)
      board.pieces.delete(@position.occupied)
      @position.occupied = self
      king = @board.pieces.select do |piece|
        piece.class == Game::King && piece.color == self.color
      end
      out_of_check = king[0].is_in_check? ? false : true
      @position = original_state
      board.space(location).occupied = old_piece
      board.pieces.push(old_piece) unless old_piece == '  '
      @position.occupied = self
      return out_of_check
    end

    def is_in_check?
      enemies = board.pieces.select { |piece| piece.color != self.color }
      return true if enemies.any? { |enemy| enemy.get_moves.include?(self.find) }
      false
    end

    def checkmate?
      return false unless is_in_check?
      allies = board.pieces.select { |piece| piece.color == self.color }
      allies.none? do |ally|
        ally.get_moves.any? do |move|
          ally.try(move)
        end
      end
    end

    def stalemate?
      return false if is_in_check?
      allies = board.pieces.select { |piece| piece.color == self.color }
      allies.none? do |ally|
        ally.get_moves.any? do |move|
          ally.try(move)
        end
      end
    end

  end

  class Queen < Piece
    def initialize(color, position, board)
      super
      self.id = color == "Black" ? "*Q" : " Q"
    end
    def find
      super
    end
    def get_moves
      return [] if self.position.nil?
      letters = ('A'..'H').to_a
      start = self.find
      directions = [[1,1],[-1,1],[-1,-1],[1,-1],[1,0],[-1,0],[0,1],[0,-1]]
      moves = []
      directions.each do |direction|
        blocked = false
        letter = letters.index(start[0])
        number = start[1].to_i
        until blocked
          letter += direction[0]
          number += direction[1]
          new_space = "#{letters[letter]}#{number}"
          break unless board.contains?(new_space)
          if board.space(new_space).occupied == '  '
            moves.push(new_space)
          elsif board.space(new_space).occupied.color != self.color
            moves.push(new_space)
            break
          else
            break
          end
        end
      end
      moves
    end

    def move(location)
      super
      moves = get_moves
      raise ArgumentError unless moves.include?(location)
      original_state = self
      old_piece = board.space(location).occupied
      @position.occupied = '  '
      @position = board.space(location)
      @position.occupied.position = nil unless @position.occupied == '  '
      @position.occupied = self
      king = @board.pieces.select do |piece|
        piece.class == Game::King && piece.color == self.color
      end
      if king[0].is_in_check?
        puts "You need to get out of check!"
        @position = original_state.position
        board.space(location).occupied = old_piece
        board.pieces.push(old_piece) unless old_piece == '  '
        @position.occupied = self
        raise InCheck
      end
    end
    def try(location)
      out_of_check = true
      original_state = self.position
      old_piece = board.space(location).occupied
      @position.occupied = '  '
      @position = board.space(location)
      board.pieces.delete(@position.occupied)
      @position.occupied = self
      king = @board.pieces.select do |piece|
        piece.class == Game::King && piece.color == self.color
      end
      out_of_check = king[0].is_in_check? ? false : true
      @position = original_state
      board.space(location).occupied = old_piece
      board.pieces.push(old_piece) unless old_piece == '  '
      @position.occupied = self
      return out_of_check
    end
  end

  class Player
    attr_reader :color
    def initialize(number, name)
      @name = name
      @color = number == 1 ? "White" : "Black"
    end
    def to_s
      @name
    end
  end
end
