class Game

	def initialize
		@turns_left = 12
		@code = []
		@started = false
		puts "Would you like to play as GUESSER or CODER?"
		send(gets.chomp.downcase)
	end

	private

	def coder
		@started = true
		puts "Think of a code composed of 4 integers from 1 to 6, and I'll try to guess it."
		puts "Press enter when you have your code."
		gets.chomp
		@turns_left -= 1
		num = 1
		numbers = ["1", "2", "3", "4", "5", "6"]
		numbersHash = {}
		correct = 0
		correct_number = 0
		previous_total = 0
		pairings = [[0,1],[0,2],[0,3],[1,2],[1,3],[2,3]]
		numbers.each do |x|
			if numbersHash.empty?
				guess = [num,num,num,num]
			else
				guess = []
				numbersHash.each do |value, quantity|
					quantity.times do
						guess.push(value)
					end
				end
				while guess.length < 4
					guess.push(num)
				end
			end
			puts "My guess is #{guess}"
			puts "How many are correct (both number and position)?"
			correct = gets.chomp.to_i
			if correct == 4
				puts "Gotcha! Better luck next time!"
				return
			end
			puts "How many are only the correct number?"
			correct_number = gets.chomp.to_i
			total_correct = correct + correct_number
			numbersHash[x.to_i] = total_correct - previous_total unless total_correct - previous_total == 0
			previous_total = total_correct
			@correct_numbers = guess and break if total_correct == 4
			num += 1
			@turns_left -= 1
		end
		previous_correct = 0
		guess = @correct_numbers
		until gg?
			@turns_left -= 1
			if correct < 2 && @best_guess.nil?
				guess = @correct_numbers.shuffle
				#puts 'if triggered'
			elsif @best_guess.nil?
				@best_guess = guess.map { |x| x }
				pairings.shuffle!
				to_swap = pairings.shift
				guess[to_swap[0]], guess[to_swap[1]] = guess[to_swap[1]], guess[to_swap[0]]
				#puts 'elsif triggered'
				#p @best_guess
			else
				swapped = false
				until swapped
					pairings.shuffle!
					to_swap = pairings.shift
					#p to_swap
					guess = @best_guess.map { |x| x }
					guess[to_swap[0]], guess[to_swap[1]] = guess[to_swap[1]], guess[to_swap[0]]
					swapped = true unless guess[to_swap[0]] == guess[to_swap[1]]
					#puts 'else triggered'
					#p @best_guess
				end
			end
			puts "My guess is #{guess}"
			puts "How many are correct (both number and position)?"
			correct = gets.chomp.to_i
			if correct == 4
				puts "Gotcha! Better luck next time!"
				puts "I won with #{@turns_left} turns left."
				return
			end
			puts "How many are only the correct number?"
			correct_number = gets.chomp.to_i
			previous_correct = correct
		end
		puts "I guess you win... this time."
	end

	def guesser
		@started = true
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
			puts "Congratulations, you guessed the code!"
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
						break
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
	puts "Do you want to PLAY or EXIT?"
	send(gets.chomp.downcase)
end