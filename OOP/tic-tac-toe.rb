class Game

	def initialize
		puts "Player 1 enter name:"
		@player_1 = Player.new(gets.chomp)

		puts "Player 2 enter name:"
		@player_2 = Player.new(gets.chomp)

		@board = Board.new(3)
		@games_played = 0
		play
	end

	def rematch
		clear_board
		play
	end

	private

	def clear_board
		@board = Board.new(3)
		@player_1.spaces = []
		@player_2.spaces = []
	end

	def show_board
		@board.spaces.each_slice(3) do |x|
			x = x.map { |y| y.to_s }
			p x
		end
	end

	def play
		puts "#{@player_1} will be 'X's, and #{@player_2} will be 'O's."
		@player_1.type = "X"
		@player_2.type = "O"
		if @games_played.even?
			@active_player = @player_1
		else
			@active_player = @player_2
		end
		until board_full?
			turn(@active_player)
			break if won?
			if @active_player == @player_1
				@active_player = @player_2
			else
				@active_player = @player_1
			end
		end
		show_board
		if won?
			puts "Congratulations #{@active_player}, you win!"
			@active_player.wins += 1
		else
			puts "It's a draw."
		end
		@games_played += 1
		puts "#{@player_1}: #{@player_1.wins} | #{@player_2}: #{@player_2.wins}"
		puts "Enter command 'play' to start a new game with new players."
		puts "Enter command 'rematch' to start a game with the same players."
		puts "Or enter command 'exit' to quit."
	end

	def turn(player)
		puts "It's #{player}'s turn!"
		valid = false
		until valid
			show_board
			puts "Enter the number of the space you want to mark:"
			selected = gets.chomp.to_i - 1
			valid = true unless @board.spaces[selected].marked
			player.claim(@board.spaces[selected])
			if valid
				@board.spaces[selected].value = "#{player.type}"
			else
				puts "That space is already selected, try again."
			end
		end
	end

	def board_full?
		return true if @board.spaces.all? { |space| space.marked }
	end

	def won?
		gg = false
		claimed_spaces = @active_player.spaces.map { |space| space.id }
		winning_combinations = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9], [3,5,7]]
		winning_combinations.each do |a|
			gg = true if (claimed_spaces & a).length == 3
		end
		gg
	end


	class Board
		include Enumerable
		attr_accessor :spaces

		def initialize(length)
			Space.reset
			@length = length
			@spaces = []
			(@length**2).times do |x|
				@spaces.push(Space.new((x + 1).to_s))
			end
		end

		class Space
			@@spaces = 0

			attr_reader :marked, :id

			def self.reset
				@@spaces = 0

			end

			def initialize(value)
				@value = value
				@id = @@spaces + 1
				@marked = false
				@@spaces += 1
			end

			def to_s
				return @value
			end

			def value
				return @value
			end

			def value=(a)
				unless @marked
					@value = a
					@marked = true
				end
			end
		end

	end

	class Player

		attr_accessor :type, :spaces, :wins

		def initialize(name)
			@name = name
			@spaces = []
			@wins = 0
		end

		def to_s
			return @name
		end

		def claim(space)
			@spaces.push(space) unless space.marked
		end
	end

end

def play
	$game = Game.new
	return
end

def rematch
	$game.rematch
end

$gg = false

def exit
	$gg = true
end

puts "Enter command 'play' to start a game."

until $gg
	begin
		command = gets.chomp.downcase
		send(command)
	rescue
		if $game.nil?
			puts "Oops, that's not a valid command. Valid commands include 'play' and 'exit.'"
		else
			puts "Oops, that's not a valid command. Valid commands include 'play,' 'rematch,' and 'exit.'"
		end
	end
end