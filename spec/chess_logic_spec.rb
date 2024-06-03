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
        @board.add_piece([3, 3], King, 'white') # King's are here just because they need to be on the board
        @board.add_piece([5, 5], King, 'black')
        @board.update_all_pieces
        @logic.board = @board
      end

      it 'returns false if the move is not valid' do
        expect(@logic.valid_move?([1, 1], [3, 2])).to be false
      end

      it 'returns true if the move is valid' do
        expect(@logic.valid_move?([1, 1], [1, 2])).to be true
      end

      it 'returns false if the king puts himself in check' do
        expect(@logic.valid_move?([3, 3], [4, 4]))
      end
    end
  end

  context 'Using the king on [5, 5]' do
    before do
      @logic = ChessLogic.new
      @board = ChessBoard.new
      @board.add_piece([7, 7], King, 'white')
      @board.add_piece([0, 0], King, 'black')
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

  describe '#pinned' do
    before do # Various situations where some pieces should be pinned
      board = ChessBoard.new
      board.add_piece([0, 0], Rook, 'white')
      board.add_piece([0, 7], King, 'black')
      board.add_piece([0, 6 ], Knight, 'black')
      board.add_piece([6, 5], Queen, 'black')
      board.add_piece([3, 2], King, 'white')
      board.add_piece([4, 3], Rook, 'white')
      board.add_piece([2, 5], Pawn, 'black')
      board.update_all_pieces
      # p is pinned and np is not pinned
      @logic = ChessLogic.new
      @logic.board = board
      @p_knight = board[[0, 6]].piece
      @p_rook = board[[4, 3]].piece
      @np_pawn = board[[2, 5]].piece
      @np_rook = board[[0, 0]].piece
    end

    it 'returns true for the pinned knight' do
      expect(@logic.pinned?(@p_knight)).to be true
    end

    it 'returns true for the pinned rook' do
      expect(@logic.pinned?(@p_rook)).to be true
    end

    it 'returns false for the pawn that\'s not pinned ' do
      expect(@logic.pinned?(@np_pawn)).to be false
    end

    it 'returns false for the rook that\'s not pinned ' do
        expect(@logic.pinned?(@np_rook)).to be false
    end
  end

  describe '#stale_mate?' do
    # Here I'm going to set up the board in the test, a context block seems unnecessary
    it 'returns true in a simple stalemate situation' do
      board = ChessBoard.new
      board.add_piece([0, 7], King, 'white')
      board.add_piece([5, 1], Queen, 'white')
      board.add_piece([7, 0], King, 'black')
      board.update_all_pieces
      logic = ChessLogic.new
      logic.board = board

      expect(logic.stale_mate?('black')).to be true
    end

    it 'returns true in a more complicated stalemate situation' do
      board = ChessBoard.new

      board.add_piece([0, 7], King, 'black')
      board.add_piece([7, 7], Rook, 'black')
      board.add_piece([6, 7], Queen, 'black')
      board.add_piece([2, 5], Knight, 'black')
      board.add_piece([0, 4], Pawn, 'black')
      board.add_piece([0, 1], Rook, 'black')
      board.add_piece([0, 3], Pawn, 'white')
      board.add_piece([2, 4], Pawn, 'white')
      board.add_piece([7, 5], Bishop, 'white')
      board.add_piece([7, 0], King, 'white')
      board.update_all_pieces
      logic = ChessLogic.new
      logic.board = board

      expect(logic.stale_mate?('white')).to be true
    end

    it 'returns false in a non-stalemate situation' do
      board = ChessBoard.new(play: true)
      logic = ChessLogic.new
      logic.board = board

      expect(logic.stale_mate?('white')).to be false
      expect(logic.stale_mate?('black')).to be false
    end
  end
end