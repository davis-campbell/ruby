class Game

	def initialize
		@mistakes_left = 6
		@word = ''
		@letters_guessed = []
		until @word.length > 4 && @word.length < 13
			@word = File.open('../5desk.txt').readlines.sample.chomp.downcase
		end
		@word_hash = {}
		@word.split('').each_with_index do |letter, index|
			@word_hash[index] = {:value => letter, :guessed => false}
		end
		puts "I'm thinking of a word..."
		play
	end

	def play
		until gg?
			puts "You have guessed these letters: #{@letters_guessed}"
			@word_hash.each_value do |x|
				if x[:guessed] == false
					print '_'
				else
					print x[:value]
				end
				print ' '
			end
			puts "\nYou can still afford #{@mistakes_left} wrong guesses."
			puts "Enter a letter."
			letter = gets.chomp
			guess(letter)
		end
		if @mistakes_left == 0
			puts "You lose..."
		else
			puts "You win..."
		end
		return nil
	end

	def guess(letter)
		if @word.include?(letter)
			puts "Yep, that's in there."
			@word_hash.each_value do |x|
				if x[:value] == letter
					x[:guessed] = true
				end
			end
		else
			puts "Nope."
			@mistakes_left -= 1
		end
		@letters_guessed.push(letter)
	end

	def gg?
		return true if @mistakes_left == 0
		@word_hash.each_value do |x|
			return false if x[:guessed] == false
		end
		return true
	end


end