require_relative '../bubblesort'


describe 'the Array Class' do
	describe 'the sorted? function' do 
	
		notinorder = [5,2,1,6,7,3]
		inorder = [1,2,3,4,5]

	
		it 'returns false for a disordered array of integers' do
			expect(notinorder).not_to be_sorted
		end

		it 'returns true for an ordered array of integers' do
			expect(inorder).to be_sorted
		end
	end
end