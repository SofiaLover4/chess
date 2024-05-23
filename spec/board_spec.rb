# frozen_string_literal: true

require_relative '../lib/board'

Dir["#{File.dirname(__FILE__)}/../lib/pieces/*.rb"].each do |file|
  require file
end

describe ChessBoard do
  describe '#[]' do
    subject(:inputs) { described_class.new }
    # Invalid inputs won't be tested here because the program has full control of how
    # this method is used.
    context 'When giving valid inputs' do
      it 'returns the correct square' do
        8.times do |i|
          8.times { |j| expect(inputs[[i, j]].coordinates).to eq([i, j]) }
        end
      end
    end
  end

  describe '#add_piece' do
    context 'add a white and a black piece to the board' do
      before do
        @board = described_class.new
        @board.add_piece([0, 0], Pawn, 'white')
        @board.add_piece([1,1], Pawn, 'black')
        @white_target = @board[[0, 0]].piece
        @black_target = @board[[1, 1]].piece
      end
      it 'includes the correct piece in @white_in_play and not in @black_in_play' do
        expect(@board.white_in_play).to include(@white_target)
        expect(@board.black_in_play).not_to include(@white_target)
      end
      it 'includes the correct piece in @black_in_play and not in @black_in_play' do
        expect(@board.white_in_play).not_to include(@black_target)
        expect(@board.black_in_play).to include(@black_target)
      end
    end

    context 'add a black and white king to the board' do
      before do
        @board = described_class.new
        @board.add_piece([0, 0], King, 'white')
        @board.add_piece([1,1], King, 'black')
        @white_king = @board[[0, 0]].piece
        @black_king = @board[[1, 1]].piece
      end

      it 'stores the white king in the correct instance variable' do
        expect(@board.white_king).to eq(@white_king)
        expect(@board.white_in_play).to include(@white_king)
      end

      it 'stores the black king in the correct instance variable' do
        expect(@board.black_king).to eq(@black_king)
        expect(@board.black_in_play).to include(@black_king)
      end
    end
  end

  describe '#move_piece' do
    before(:each) do
      @board = described_class.new
      @board.add_piece([1, 0], Knight, 'white')
      @board.add_piece([0, 2], Pawn, 'white')
      @board.add_piece([2, 2], Pawn, 'black')
      @knight = @board[[1, 0]].piece
      @pawn = @board[[2, 2]].piece
    end

    it 'raises the correct errors' do
      expect { @board.move_piece([-1, 0], [0, 0]) }.to raise_error(StandardError, 'trying to access coordinates out of bounds')
      expect { @board.move_piece([1, 0], [10, 12])}.to raise_error(StandardError, 'trying to access coordinates out of bounds')
      expect { @board.move_piece([1, 0], [0, 2])}.to raise_error(StandardError, 'friendly piece trying to be captured')
      expect { @board.move_piece([0,0], [1, 0])}.to raise_error(StandardError, 'no piece in this square')
    end

    context 'a knight will capture a pawn' do
      before do
        @board.move_piece([1, 0], [2, 2])
      end

      it 'updates the moved piece and taken out piece ccoordinate\'s correctly ' do
        expect(@knight.coordinates).to eq([2, 2])
        expect(@pawn.coordinates).to eq(nil)
      end

      # Pawn should be in the black_out set and taken out of the black_in_play set
      it 'updates the correct sets' do
        expect(@board.white_in_play).to include(@knight)
        expect(@board.white_out).not_to include(@knight)
        expect(@board.black_in_play).not_to include(@pawn)
        expect(@board.black_out).to include(@pawn)
      end

    end

  end
end
