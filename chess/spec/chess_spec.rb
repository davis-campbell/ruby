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
    describe '#space' do
      it 'returns the identity of a space' do
        expect(board.space('A8')).to eq(board[0][0])
        expect(board.space('E4')).to eq(board[4][4])
        expect(board.space('D6')).to eq(board[2][3])
      end
    end
    describe Game::Board::Space do
      describe '#id' do
        it 'returns, in standard notation, the location of a space' do
          expect(board[0][0].id).to eq('A8')
          expect(board[4][5].id).to eq('F4')
        end
      end
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
    describe '#get_moves' do
      it 'allows a pawn to move forward either one or two spaces at the beginning' do
        expect(board[6][0].occupied.get_moves).to include('A3', 'A4')
        expect(board[1][0].occupied.get_moves).to include('A6', 'A5')
        expect(board[1][7].occupied.get_moves).to include('H6', 'H5')
      end
    end
  end
  describe Game::Rook do
    describe '#get_moves' do
      before do
        @board = board
        @board.space('A7').occupied = '  '
      end
      it 'returns valid moves for a Rook' do
        expect(@board.space('A8').occupied.get_moves).to include('A7','A6','A5','A4','A3','A2')
        expect(@board.space('H8').occupied.get_moves).to be_empty
      end
    end
  end
  describe Game::Knight do
    describe '#get_moves' do
      it 'returns valid moves for a Knight' do
        expect(board.space('G1').occupied.get_moves).to include('F3','H3')
        expect(board.space('G1').occupied.get_moves).not_to include('E2')
      end
    end
  end
  describe Game::Bishop do
    describe '#get_moves' do
      before do
        @board = board
        @board.space('E2').occupied = '  '
      end
      it 'returns valid moves for a Bishop' do
        expect(board.space('F1').occupied.get_moves).to include('E2','D3','C4','B5','A6')
        expect(board.space('F1').occupied.get_moves).not_to include('G2','H3')
      end
    end
  end
  describe Game::King do
  end
  describe Game::Queen do
  end
end
