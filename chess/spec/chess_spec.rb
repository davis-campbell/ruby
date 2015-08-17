require_relative "../chess"

describe Game do
    let(:newgame) do
      game = Game::Board.new
      game.setup
      game
    end

    let(:board) { Game::Board.new }
  describe Game::Board do

    describe '#new' do

      it 'generates an array of arrays of Space instances' do
        expect(board[0]).to be_an_instance_of Array
        expect(board[0][0]).to be_an_instance_of Game::Board::Space
      end

      it 'is 8 by 8' do
        expect(board[0].length).to eq(8)
        expect(board.length).to eq(8)
      end
    end
    describe '#setup' do
      it 'places the right pieces in the right spots' do
        expect(newgame[0][0].occupied).to be_an_instance_of Game::Rook
        expect(newgame[0][1].occupied).to be_an_instance_of Game::Knight
        expect(newgame[0][2].occupied).to be_an_instance_of Game::Bishop
        expect(newgame[0][4].occupied).to be_an_instance_of Game::King
        expect(newgame[0][3].occupied).to be_an_instance_of Game::Queen
        expect(newgame[1][0].occupied).to be_an_instance_of Game::Pawn
        expect(newgame[7][4].occupied).to be_an_instance_of Game::King
        expect(newgame[7][3].occupied).to be_an_instance_of Game::Queen
      end
      it 'puts black on one side and white on the other' do
        newgame[0].each { |space| expect(space.occupied.color).to eq("Black") }
        newgame[1].each { |space| expect(space.occupied.color).to eq("Black") }
        newgame[6].each { |space| expect(space.occupied.color).to eq("White") }
        newgame[7].each { |space| expect(space.occupied.color).to eq("White") }
      end
    end
    describe '#space' do
      it 'returns the identity of a space' do
        expect(newgame.space('A8')).to eq(newgame[0][0])
        expect(newgame.space('E4')).to eq(newgame[4][4])
        expect(newgame.space('D6')).to eq(newgame[2][3])
      end
    end
    describe Game::Board::Space do
      describe '#id' do
        it 'returns, in standard notation, the location of a space' do
          expect(newgame[0][0].id).to eq('A8')
          expect(newgame[4][5].id).to eq('F4')
        end
      end
    end
  end
  describe Game::Player do
  end
  describe Game::Piece do
    describe '#find' do
      it 'returns the coordinates of the square on which it is located' do
        expect(newgame[0][0].occupied.find).to eq('A8')
        expect(newgame[7][4].occupied.find).to eq('E1')
      end
    end
  end
  describe Game::Pawn do
    describe '#moved?' do
      it 'returns false on pawns that have not moved' do
        expect(newgame[1][0].occupied.moved?).to be false
      end
    end
    describe '#get_moves' do
      it 'allows a pawn to move forward either one or two spaces at the beginning' do
        expect(newgame[6][0].occupied.get_moves).to include('A3', 'A4')
        expect(newgame[1][0].occupied.get_moves).to include('A6', 'A5')
        expect(newgame[1][7].occupied.get_moves).to include('H6', 'H5')
      end
    end
  end
  describe Game::Rook do
    describe '#get_moves' do
      before do
        @board = board
        @board.space('D4').occupied = Game::Rook.new("White", @board.space('D4'), @board)
        @board.space('D8').occupied = Game::Pawn.new("Black", @board.space('D8'), @board)
        @board.space('D1').occupied = Game::Pawn.new("White", @board.space('D1'), @board)
      end
      it 'returns valid moves for a Rook' do
        expect(@board.space('D4').occupied.get_moves).to contain_exactly('A4','B4','C4','E4','F4','G4','H4','D3','D2','D5','D6','D7','D8')
      end
    end
  end
  describe Game::Knight do
    describe '#get_moves' do
      before do
        @board = board
        @board.space('D2').occupied = Game::Knight.new("White", @board.space('D2'), @board)
        @board.space('E4').occupied = Game::Knight.new("Black", @board.space('E4'), @board)
        @board.space('B1').occupied = Game::Knight.new("White", @board.space('B1'), @board)
      end
      it 'returns valid moves for a Knight' do
        expect(@board.space('D2').occupied.get_moves).to contain_exactly('B3','C4','E4','F3','F1')
      end
    end
  end
  describe Game::Bishop do
    describe '#get_moves' do
      before do
        @board = board
        @board.space('D4').occupied = Game::Bishop.new("White", @board.space('D4'), @board)
        @board.space('H8').occupied = Game::Pawn.new("Black", @board.space('H8'), @board)
        @board.space('A1').occupied = Game::Pawn.new("White", @board.space('A1'), @board)
        @board.space('B6').occupied = Game::Pawn.new("Black", @board.space('B6'), @board)
        @board.space('F2').occupied = Game::Pawn.new("White", @board.space('F2'), @board)
      end
      it 'returns valid moves for a Bishop' do
        expect(@board.space('D4').occupied.get_moves).to contain_exactly('E5','F6','G7','H8','C3','B2','E3','C5','B6')
      end
    end
  end
  describe Game::King do
    describe '#get_moves' do
      before do
        @board = board
        @board.space('D4').occupied = Game::King.new("White", @board.space('D4'), @board)
        @board.space('C4').occupied = Game::Pawn.new("White", @board.space('C4'), @board)
        @board.space('D5').occupied = Game::Pawn.new("Black", @board.space('D5'), @board)
        @board.space('E6').occupied = Game::Pawn.new("Black", @board.space('E6'), @board)
      end
      it 'returns valid moves for a king' do
        expect(@board.space('D4').occupied.get_moves).to contain_exactly('C3','C5','D3','D5','E3','E4','E5')
      end
    end
  end
  describe Game::Queen do
  end
end
