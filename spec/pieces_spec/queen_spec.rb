# frozen_string_literal: true


require_relative '../../lib/pieces/queen'
require_relative '../../lib/board'

# Queen testing should be straight forward, after all, the methods used
# have already been tested heavily with the rook and bishop

describe Queen do
  before(:each) { @chess_board = ChessBoard.new }
  describe '#update_possible_moves' do
    context 'a queen on the bottom right with a few friendly and team pieces surrounding' do
      before do
        @chess_board.add_piece([6, 5], Queen, 'white')
        @chess_board.add_piece([4, 4], Queen, 'white')
        @chess_board.add_piece([6, 2], Queen, 'black')
        @chess_board.add_piece([4, 0], Queen, 'black')
        @target_piece = @chess_board[[6, 2]].piece
        @target_piece.update_possible_moves
      end

      it 'updates to the correct possible cross moves ' do
        expect(@target_piece.possible_moves).to include([6, 3], [6, 4], [6, 5], [7, 2], [6, 1], [6, 0])
        6.times { |i| expect(@target_piece.possible_moves).to include([5 - i, 2]) } # Checking the long left line
      end

      it 'updates the correct possible diagonal moves' do
        expect(@target_piece.possible_moves).to include([7, 3], [7, 1], [5, 3], [5, 1])
      end
    end
  end

  describe '#dump_json and #load_json' do
    # This is the same method that will be used for Bishop and Knight so this will be the only test case
    it 'creates a new queen with the same instance variables' do
      board = ChessBoard.new
      board.add_piece([5, 5], Queen, 'black')
      old_queen = board[[5, 5]].piece
      board.update_all_pieces

      string = old_queen.dump_json
      new_queen = Queen.load_json(string, board)

      expect(new_queen.team).to eq(old_queen.team)
      expect(new_queen.coordinates).to eq(old_queen.coordinates)
      expect(new_queen.possible_moves).to eq(old_queen.possible_moves)
    end

  end
end