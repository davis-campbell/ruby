require_relative "../chess"

describe Game do
    let(:board) { Game::Board.new }
  describe Game::Board do

    describe '#new' do

      it 'generates an array of arrays of Space instances' do
        expect(board[0]).to be_an_instance_of Array
        expect(board[0][0]).to be_an_instance_of Game::Board::Space
      end

      it 'has the right pieces in the right spots' do
        expect(board[0][0].occupied).to be_an_instance_of Game::Rook
        expect(board[0][1].occupied).to be_an_instance_of Game::Knight
        expect(board[0][2].occupied).to be_an_instance_of Game::Bishop
        expect(board[0][4].occupied).to be_an_instance_of Game::King
        expect(board[0][3].occupied).to be_an_instance_of Game::Queen
        expect(board[1][0].occupied).to be_an_instance_of Game::Pawn
        expect(board[7][4].occupied).to be_an_instance_of Game::King
        expect(board[7][3].occupied).to be_an_instance_of Game::Queen
      end

      it 'puts black on one side and white on the other' do
        board[0].each { |space| expect(space.occupied.color).to eq("Black") }
        board[1].each { |space| expect(space.occupied.color).to eq("Black") }
        board[6].each { |space| expect(space.occupied.color).to eq("White") }
        board[7].each { |space| expect(space.occupied.color).to eq("White") }
      end

      it 'is 8 by 8' do
        expect(board[0].length).to eq(8)
        expect(board.length).to eq(8)
      end

      it 'contains alternating black and white spaces' do
        expect(board[0][0].color).to eq('White')
        expect(board[0][1].color).to eq('Black')
        expect(board[1][0].color).to eq('Black')
        expect(board[7][7].color).to eq('White')
        expect(board[7][6].color).to eq('Black')
      end
    end
    describe '#locate' do
      it 'returns the identity of a space' do
        expect(board.locate('A8')).to eq(board[0][0])
        expect(board.locate('E4')).to eq(board[4][4])
        expect(board.locate('D6')).to eq(board[2][3])
      end
    end
    describe Game::Board::Space do
    end
  end
  describe Game::Player do
  end
  describe Game::Piece do
    describe '#find' do
      it 'returns the coordinates of the square on which it is located' do
        expect(board[0][0].occupied.find).to eq('A8')
        expect(board[7][4].occupied.find).to eq('E1')
      end
    end
  end
  describe Game::Pawn do
    describe '#moved?' do
      it 'returns false on pawns that have not moved' do
        expect(board[1][0].occupied.moved?).to be false
      end
    end
  end
  describe Game::Rook do
  end
  describe Game::Knight do
  end
  describe Game::Bishop do
  end
  describe Game::King do
  end
  describe Game::Queen do
  end
end
