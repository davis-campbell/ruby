def caesar_cipher(string, shift)
	shift = shift % 26
  characters = string.split('')
  newCharacters = []
  characters.each do |char|
  	a = char.ord
  	a += shift
  	if /[A-Z]/.match(char).nil? == false
    	if a < 65
    		a += 26
    	elsif a > 90
    		a -= 26
    	end
    newCharacters.push(a.chr)
    elsif /[a-z]/.match(char).nil? == false
    	if a < 97
    		a += 26
    	elsif a > 122
    		a -= 26
    	end
    newCharacters.push(a.chr)
    else
    	newCharacters.push(char)
    end
  end
  newCharacters.join('')
end
