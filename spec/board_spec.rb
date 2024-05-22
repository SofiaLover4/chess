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
end
