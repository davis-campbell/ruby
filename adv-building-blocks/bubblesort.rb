class Array
	def sorted?
		a = self.length - 1
		a.times do |x|
			if self[x].class == Fixnum and self[x] > self[x + 1]
				return (false)
			elsif self[x].class == String and self[x].length > self[x + 1].length
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

def bubble_sort_by(array)
	n = array.length - 1
	until array.sorted?
		n.times do |x|
			if (yield array[x], array[x + 1]) < 0
				array[x], array[x + 1] = array[x + 1], array[x]
			end
		end
	end
	array
end
