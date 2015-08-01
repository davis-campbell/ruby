module Enumerable

	def my_each
		if block_given?
			a = 0
			self.length.times do
				yield self[a]
				a += 1
			end
			self
		else
			self.to_enum
		end
	end

	def my_each_with_index
		if block_given?
			a = 0
			self.length.times do
				yield self[a], a
				a += 1
			end
			self
		else
			self.to_enum
		end
	end

	def my_select
		if block_given?
			newArray = []
			self.my_each do |x|
				if yield x
					newArray << x
				end
			end
			newArray
		else
			self.to_enum
		end
	end

	def my_all?
		if block_given?
			self.my_each { |x| return (false) if not yield x }
			true
		else
			self.my_each { |x| return (false) if x == false or x == nil } 
			true
		end
	end

	def my_any?
		if block_given?
			self.my_each { |x| return (true) if yield x }
			false
		else
			self.my_each { |x| return (true) unless x == false or x == nil }
		false
		end
	end
	
	def my_none?
		if block_given?
			self.my_each { |x| return (false) if yield x }
			true
		else
			self.my_each { |x| return (false) unless x == true}
			true
		end
	end
	
	def my_count(a = nil)
		if block_given?
			y = 0
			self.my_each { |x| y += 1 if yield x }
			return(y)
		elsif a.nil?
			return (self.length)
		else
			y = 0
			self.my_each { |x| y += 1 if x == a }
		end
		y
	end
	
	def my_map(a = nil)
		'''The instructions seemed sort of ambiguous for this one. The method defined
		executes a block and a proc, executing the block before the proc if there is
		a block given. If no proc is given, then it returns an enumerator.'''
		if a !=  nil
			newArray = []
			if block_given?
				self.my_each { |el| newArray.push(yield el) }
			else
				newArray = self
			end
			newArray2 = []
			newArray.my_each { |el| newArray2.push(a.call(el)) }
			newArray2
		else
			self.to_enum
		end
	end

	def my_inject(*a)
		if a[0].class == Fixnum
			memo = a[0]
			count = 1
		else
			memo = self[0]
			count = 0
		end
		if block_given?
			self.my_each do |x|
				memo = yield memo, x unless count == 0
				count += 1
			end
			return memo
		else
			self.my_each do |x|
				memo = x.send a[-1], memo unless count == 0
				count += 1
			end
			return memo
		end
	end


end

def multiply_els(array)
	array.my_inject(:*)
end
