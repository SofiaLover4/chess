# frozen_string_literal: true

require_relative '../lib/chess_logic'

describe ChessLogic do
  describe '#valid_move?' do
    context 'theres a queen on [1, 1] with a enemy pawn on [1, 2]' do
      before do
        @logic = ChessLogic.new
        @board = ChessBoard.new
        @board.add_piece([1, 1], Queen, 'white')
        @board.add_piece([1, 2], Pawn, 'black')
        @board.update_all_pieces
        @game.board = @board
      end

      it 'returns false if no piece is selected' do
        expect(@game.valid_move?([7, 7], [1, 3])).to be false
      end

      it 'returns false if the move is not valid' do
        expect(@game.valid_move?([1, 1], [3, 2])).to be false
      end

      it 'returns true if the move is valid' do
        expect(@game.valid_move?([1, 1], [1, 2])).to be true
      end
    end
  end

  context 'Using the king on [5, 5]' do
    before do
      @logic = ChessLogic.new
      @board = ChessBoard.new
      @board.add_piece([7, 7], King, 'white')
      @board.update_all_pieces
      @king = @board[[7, 7]].piece
      @logic.board = @board
    end
    it 'returns true for all possible moves when there are no enemy pieces on the board' do
      @king.possible_moves.each do |move|
        expect(@logic.valid_move?([7, 7], move)).to be true
      end
    end

    it 'returns false for all possible moves when all the possible moves could be under attack' do
      # This is also gonna be for how to to check if the king is in checkmate
      @board.add_piece([5, 7], Rook, 'black')
      @board.add_piece([6, 5], Queen, 'black')
      @board.update_all_pieces
      @king.possible_moves.each do |move|
        expect(@logic.valid_move?([7, 7], move)).to be false
      end
    end
  end
end