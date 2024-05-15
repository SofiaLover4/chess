# frozen_string_literal: true

require_relative '../../lib/board'
require_relative '../../lib/pieces/knight'

# This testing will look slightly different than other pieces. The knight's moves are determined is simpler than other
# pieces so it should be more straight forward. We will only be testing the #update_possible moves functionality

describe Knight do
  describe '#update_possible_moves' do
    context 'With three knights on the board' do
      before do
        @chessboard = ChessBoard.new
        @chessboard.add_piece([5, 4], Knight, 'black')
        @chessboard.add_piece([3, 3], Knight, 'white')
        @chessboard.add_piece([6, 2], Knight, 'black')
        @middle_knight = @chessboard[[3, 3]].piece
        @capture_knight = @chessboard[[5, 4]].piece
        @edge_knight = @chessboard[[6, 2]].piece
        [@middle_knight, @edge_knight, @capture_knight].each(&:update_possible_moves)
      end

      it 'capture knight\'s all possible moves except [6, 2]' do
        expect(@capture_knight.possible_moves).not_to include([6, 2])
        expect(@capture_knight.possible_moves).to include([3, 3], [3, 5], [4, 2], [7, 5], [7, 3], [4, 6], [6, 6])
      end

      it 'edge knight doesn\'t have moves that go off the edge' do
        expect(@edge_knight.possible_moves).not_to include([8, 3], [8, 1])
      end
    end
  end
end