# frozen_string_literal: true

require_relative '../../lib/board'
require_relative '../../lib/pieces/king'

# Last piece to test!

describe King do
  describe '#update_possible_moves' do
    before(:each) do
      @chessboard = ChessBoard.new
    end
    context 'when king is surrounded' do
      before do
        @chessboard.add_piece([7, 7], King, 'white')
        @chessboard.add_piece([6, 6], King, 'white')
        @chessboard.add_piece([7, 6], King, 'white')
        @chessboard.add_piece([6, 7], King, 'white')
        @target_piece = @chessboard[[7, 7]].piece
        @target_piece.update_possible_moves
      end

      it 'possibles moves should be an empty set' do
        expect(@target_piece.possible_moves).to be_empty
      end
    end

    context 'when king has some friendly and some enemy pieces' do
      before do
        @chessboard.add_piece([4, 4], King, 'white')
        @chessboard.add_piece([5, 5], King, 'black')
        @chessboard.add_piece([3, 3], King, 'white')
        @chessboard.add_piece([4, 5], King, 'white')
        @chessboard.add_piece([3, 4], King, 'black')
        @target_piece = @chessboard[[4, 4]].piece
        @target_piece.update_possible_moves
      end

      it 'possible moves has the correct moves' do
        expect(@target_piece.possible_moves).to include([3, 5], [5, 5], [5, 4], [5, 3], [4, 3], [3, 4])
        expect(@target_piece.possible_moves).not_to include([3, 3], [4, 5])
      end
    end
  end
end