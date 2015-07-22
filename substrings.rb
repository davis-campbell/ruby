def substrings(string, array)
	frequencies = Hash.new(0)
	words = string.split(' ')
	words.each do |word|
		word.downcase!
		combinations = find_combinations(word)
		combinations.each do |x|
			if array.include?(x)
				frequencies[x] += 1
			end
		end
	end
	frequencies
end




def find_combinations(word)
	combinations = []
	counter1 = 0
	counter2 = 0
	until counter1 == word.length
		combinations.push(word[counter1..counter2])
		counter2 += 1
		if counter2 == word.length
			counter1 += 1
			counter2 = counter1
		end
	end
	combinations
end