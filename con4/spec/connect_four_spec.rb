require_relative '../connect_four'

describe Game do

  before :all do
    @game = Game.new
  end

  describe '#new' do
    it 'generates a Board' do
      expect(@game.board).to be_an_instance_of Game::Board
    end

    it 'gives Player 1 the first turn' do
      expect(@game.player1.is_turn).to be true
      expect(@game.player2.is_turn).to be false
    end
  end

  describe '#gg?' do
    let (:gameover) { game = Game.new
                      game.board.each { |column| column.each { |space| space.mark('Dave') } }
                      return game
                    }
    let (:davewins) { game = Game.new
                      4.times do
                        game.player1.claim(1)
                      end
                      return game
                    }

    it 'returns false when there are empty spaces and there is no winner' do
      expect(@game.gg?).to be false
    end

    it 'returns true when all spaces are filled' do
      expect(gameover.gg?).to be true
    end

    before { @newgame = davewins}

    it 'returns player object when a player has a winning combination' do
      expect(@newgame.gg?).to eq(@newgame.player1)
    end
  end

  describe '#active_player' do

    it 'recognizes whose turn it is' do
      expect(@game.active_player).to eq(@game.player1)
    end
  end

  describe Game::Player do

    describe '#claim' do
      before :all do
        @game.player1.claim(1)
      end
      it 'lets player mark a valid space' do
        expect(@game.board[0][0].marked).to eq(@game.player1)
      end

      it "includes that space in an array of the player's spaces" do
        expect(@game.player1.spaces).to eq([@game.board[0][0]])
      end

      before { @game.board[0].each { |space| space.mark(@game.player1) } }
      it 'claim a space in a full column' do

        expect{ @game.player1.claim(1) }.to raise_exception(RuntimeError)
      end

      it 'raises an exception if the player chooses a non-existent column' do
        expect{ @game.player1.claim(0) }.to raise_exception(RangeError)
      end

    end
  end


  describe Game::Board do

    it 'inherits from Array' do
      expect(Game::Board.superclass).to eq(Array)
    end

    before :all do
      @board = Game::Board.new
    end

    describe '#new' do
      it 'creates a new Board object' do
        expect(@board).to be_an_instance_of Game::Board
      end

      it 'makes an array with 7 arrays of 6 instances of Space' do
        expect(@board[0]).to be_an_instance_of Array
        expect(@board[6]).to be_an_instance_of Array
        expect(@board[0][0]).to be_an_instance_of Game::Space
        expect(@board[6][5]).to be_an_instance_of Game::Space
      end
    end

    describe '#display' do
      it 'prints the board to the screen' do

      end
    end

  end

  describe Game::Space do

    before :all do
      @space = Game::Space.new
    end

    before :all do
      @board = Game::Board.new
      @board[0][0].mark('Dave')
    end

    describe '#new' do
      it 'creates a new Space' do
        expect(@space).to be_an_instance_of Game::Space
      end

      it 'creates unmarked Space objects' do
        expect(@space).not_to be_marked
      end
    end

    describe '#mark' do

      before :each do
        @space.mark('Dave')
      end

      it 'marks a Space' do
        expect(@space).to be_marked
      end

      it 'claims Space for player' do
        expect(@space.marked).to eq('Dave')
      end

    end

    describe '#below' do

      it 'returns the Space beneath it on the Board' do
        expect(@board[0][1].below).to eq(@board[0][0])
      end

      it 'returns nil when there is no Space beneath it' do
        expect(@board[0][0].below).to be_nil
      end
    end

    describe '#valid?' do

      it 'returns true when the space is unmarked and has no unmarked spaces beneath it' do
        expect(@board[0][1]).to be_valid
        expect(@board[1][0]).to be_valid
      end

      it 'returns false when the space is marked' do
        expect(@board[0][0]).not_to be_valid
      end

      it 'returns false when there is an unmarked space below it' do
        expect(@board[0][5]).not_to be_valid
      end

    end

  end

end
