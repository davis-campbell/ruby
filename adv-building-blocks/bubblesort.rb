class Array
	def sorted?
		a = self.length - 1
		a.times do |x|
			if self[x] > self[x+1]
				return (false)
			end
		end
		true
	end
end

def bubble_sort(array)
	n = array.length - 1
	until array.sorted?
		n.times do |a|
			x = array[a]
			y = array[a + 1]
			if x > y
				array[a], array[a + 1] = array[a + 1], array[a]
			end
		end
	end
	array
end