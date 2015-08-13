class Game
  attr_reader :board, :player1, :player2



  def initialize
    @board = Board.new
    print "Player 1, enter name: "
    @player1 = Player.new(@board, gets.chomp, 1)
    print "Player 2, enter name: "
    @player2 = Player.new(@board, gets.chomp, 2)
    @player1.is_turn = true
    @player2.is_turn = false
    @winning_combinations = []
    @board.each do |column| # Adds vertical winning combinations
      3.times do |x|
        combination = []
        4.times do |y|
          combination << column[x + y]
        end
        @winning_combinations << combination
      end
    end

    6.times do |x|  # Adds horizontal winning combinations
      4.times do |y|
        combination = []
        4.times do |z|
          combination << @board[y + z][x]
        end
        @winning_combinations << combination
      end
    end

    4.times do |x| # Adds diagonal '/' winning combinations
      3.times do |y|
        combination = []
        4.times do |z|
          combination << @board[y + z][x + z]
        end
        @winning_combinations << combination
      end
    end

    4.times do |x| # Adds diagonal '\' winning combinations
      3.times do |y|
        combination = []
        4.times do |z|
          combination << @board[y + z][x + 3 - z]
        end
        @winning_combinations << combination
      end
    end

    play
  end


  def active_player
    active_player = @player1.is_turn ? @player1 : @player2
    active_player
  end

  def play
    until gg?
      puts "#{active_player.name}, it's your turn."
      @board.display
      puts "Enter the number of the column you want: "
      column = gets.chomp.to_i
      begin
        active_player.claim(column)
      rescue
        puts "Oops, that wasn't a valid move, try again."
        play
      end
      @player1.is_turn, @player2.is_turn = @player2.is_turn, @player1.is_turn unless gg?
    end
    if gg? == true
      puts "It's a draw"
    else
      @board.display
      puts "Congratulations, #{gg?}! You win!"
    end
  end

  def gg?
    if @board.all? { |column| column.all? { |space| space.marked? } }
      return true
    end
    if @winning_combinations.any? { |combo| (combo & active_player.spaces).length == 4 }
      return active_player.name
    end
    return false
  end

  class Player
    attr_accessor :is_turn
    attr_reader :board, :name, :spaces, :id

    def initialize(board, name, id)
      @board = board
      @name = name
      @id = id
      @spaces = []
    end

    def claim(column)
      index = column - 1
      raise RangeError, "Must pick from 1 to 7" if column < 1 || column > 7
      raise "Column is already full" if board[index].all?(&:marked?)
      board[index].each do |space|
        next if space.marked?
        space.mark(self)
        @spaces << space
        break
      end

    end


  end

  class Board < Array
    def initialize
      7.times do |x|
        column = []
        6.times do
          column.push(Space.new)
        end
        column.each do |space|
          unless column.index(space) == 0
            space.below = column[column.index(space) - 1]
          else
            space.below = nil
          end
        end
        self.push(column)
      end
    end

    def display
      working_array = self.map { |column| column.reverse }
      6.times do |x|
        7.times do |y|
          print "#{working_array[y][x].value} "
        end
        print "\r\n"
      end
      print "\r\n"
      print "1 2 3 4 5 6 7\r\n"
    end

  end

  class Space
    attr_reader :marked, :value
    attr_accessor :below

    def initialize
      @marked = false
    end

    def marked?
      return true if @marked
      false
    end

    def value
      return 0 if !marked?
      return 1 if marked.id == 1
      return 2 if marked.id == 2
      return 'x'
    end

    def mark(player)
      @marked = player
    end

    def valid?
      begin
        if below.marked? && !self.marked?
          return true
        end
      rescue
        if below.nil? && !self.marked?
          return true
        end
      end
      false
    end

  end
end

def play_game
  game = Game.new
end

play_game
