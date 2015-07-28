class Game

	def initialize
		@turns_left = 12
		@code = []
		play
	end

	private

	def play
		4.times { @code << (rand(6) + 1) }
		until gg?
			@turns_left -= 1
			puts "Enter guess (4 integers from 1 to 6, separated by spaces):"
			guess = gets.chomp.split(' ').map { |x| x.to_i }
			won = true if guess == @code
			break if won
			compare(guess, @code)
		end
		if won
			puts "Congratulations, you win!"
			return @code
		else
			puts "Better luck next time."
			puts "The code was #{@code}"
		end
	end

	def gg?
		return true if @turns_left == 0
	end

	def compare(array1, array2)
		correct = 0
		correct_number = 0
		working_code = array2.map { |x| x.to_i }
		array1.each do |x|
			working_code.each do |y|
				if x == y
					if array1.index(x) == working_code.index(y)
						correct += 1
						array1[array1.index(x)] = 0
						working_code[working_code.index(y)] = 0
						break
					else
						array1[array1.index(x)] = 0
						working_code[working_code.index(y)] = 0
						correct_number += 1
					end
				end
			end
		end
		puts "Correct: #{correct} | Correct Number: #{correct_number}"
	end

end



$gg = false

def play
	game = Game.new
	return 'Good game!'
end

def exit
	$gg = true
end

until $gg
	puts "Enter either the command 'play' or the command 'exit.'"
	begin
		send(gets.chomp.downcase)
	rescue
		puts "That's not a valid command. Valid commands include 'play' and 'exit.'"
	end
end