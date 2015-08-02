class Game

	def initialize
		@turns_left = 6
		@word = ''
		until @word.length > 4 && @word.length < 13
			@word = File.open('../5desk.txt').readlines.sample.chomp.downcase
		end
		puts "I'm thinking of a word..."
		play
	end

	def play
		puts "Enter a letter."
		letter = gets.chomp
		guess(letter)
	end

	def guess(letter)
		if @word.contains?(letter)
			puts "Yep, that's in there."
		else
			puts "Nope."
		end
	end

	def contains?(letter)
		return true if self.split('').include?(letter)
	end

end