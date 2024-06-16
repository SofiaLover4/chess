# frozen_string_literal: true

require_relative '../../lib/pieces/pawn'
require_relative '../../lib/board'

describe Pawn do
  before(:each) do
    @chess_board = ChessBoard.new
  end
  describe 'white_capture_moves' do
    context 'When piece is on [0, 4] but no enemy piece' do
      it 'returns an empty set' do
        @chess_board.add_piece([0, 4], Pawn, 'white')
        result = Set.new
        expect(@chess_board[[0, 4]].piece.white_capture_moves).to eq(result)
      end
    end

    context 'When there is a piece is on [0, 4] with enemy piece on [1, 5]' do
      it 'returns {[1, 5]}' do
        @chess_board.add_piece([0, 4], Pawn, 'white')
        @chess_board.add_piece([1, 5], Pawn, 'black')
        result = Set[[1, 5]]
        expect(@chess_board[[0, 4]].piece.white_capture_moves).to eq(result)
      end
    end

    context 'When there is a piece on [7, 1] with an enemy piece on [6, 2]' do
      it 'returns {[6, 2]}' do
        @chess_board.add_piece([7, 1], Pawn, 'white')
        @chess_board.add_piece([6, 2], Pawn, 'black')
        result = Set[[6, 2]]
        expect(@chess_board[[7, 1]].piece.white_capture_moves).to eq(result)
      end
    end

    context 'When piece is on [3, 4] and there is an team piece on [4, 5] and enemy piece on [2, 5]' do
      it 'returns {[2, 5]}' do
        @chess_board.add_piece([3, 4], Pawn, 'white')
        @chess_board.add_piece([4, 5], Pawn, 'white')
        @chess_board.add_piece([2, 5], Pawn, 'black')
        result = Set[[2, 5]]
        expect(@chess_board[[3, 4]].piece.white_capture_moves).to eq(result)
      end
    end

    describe '#white_moves' do
      context 'When there is a piece on [3, 1] with no blocking pieces' do
        before(:each) { @chess_board.add_piece([3, 1], Pawn, 'white')}
        it 'returns {[3, 2], [3, 3]} if it hasn\'t moved' do
          result = Set[[3, 2], [3, 3]]
          expect(@chess_board[[3, 1]].piece.white_moves).to eq(result)
        end
        it 'returns {[3, 2]} if it has moved' do
          @chess_board[[3, 1]].piece.moved = true
          result = Set[[3, 2]]
          expect(@chess_board[[3, 1]].piece.white_moves).to eq(result)
        end
      end


      context 'When there is a piece on [3, 1] and a friendly piece on [3, 2]' do
        it 'returns and empty set' do
          @chess_board.add_piece([3, 1], Pawn, 'white')
          @chess_board.add_piece([3, 2], Pawn, 'white')
          result = Set.new
          expect(@chess_board[[3, 1]].piece.white_moves).to eq(result)
        end
      end

      context 'When there is a piece on [3, 1] and an enemy piece on [3, 3]' do
        it 'returns {[3, 2]}' do
          @chess_board.add_piece([3, 1], Pawn, 'white')
          @chess_board.add_piece([3, 3], Pawn, 'black')
          result = Set[[3, 2]]
          expect(@chess_board[[3, 1]].piece.white_moves).to eq(result)
        end
      end

      context 'When there is a piece on [2, 6]' do
        it 'returns {[2, 7]}' do
          @chess_board.add_piece([2, 6], Pawn, 'white')
          result = Set[[2, 7]]
          expect(@chess_board[[2, 6]].piece.white_moves).to eq(result)
        end
      end
    end
  end

  describe '#black_capture_moves' do
    context 'When there is a piece on [0, 6] but no enemy piece on [1, 5]' do
      it 'returns an empty set' do
        @chess_board.add_piece([0, 6], Pawn, 'black')
        result = Set.new
        expect(@chess_board[[0, 6]].piece.black_capture_moves).to eq(result)
      end

      context 'When there is a piece on [0, 6] and an enemy piece on [1, 5]' do
        it 'returns {[1, 5]}' do
          @chess_board.add_piece([0, 6], Pawn, 'black')
          @chess_board.add_piece([1, 5], Pawn, 'white')
          result = Set[[1, 5]]
          expect(@chess_board[[0, 6]].piece.black_capture_moves).to eq(result)
        end
      end

      context 'When there is a piece on [7, 3] and an enemy piece on [6, 2]' do
        it 'returns {[6, 4]}' do
          @chess_board.add_piece([7, 3], Pawn, 'black')
          @chess_board.add_piece([6, 2], Pawn, 'white')
          result = Set[[6, 2]]
          expect(@chess_board[[7, 3]].piece.black_capture_moves).to eq(result)
        end
      end

      context 'When there is a piece on [3, 5] with a team piece on [4, 4] and enemy piece on [2, 4]' do
        it 'returns {[2, 4]}' do
          @chess_board.add_piece([3, 5], Pawn, 'black')
          @chess_board.add_piece([4, 4], Pawn, 'black')
          @chess_board.add_piece([2, 4], Pawn, 'white')
          result = Set[[2, 4]]
          expect(@chess_board[[3, 5]].piece.black_capture_moves).to eq(result)
        end
      end
    end
  end

  describe '#black_moves' do
    context 'When there is a piece on [4, 5] with no blocking pieces' do
      before(:each) {@chess_board.add_piece([4, 5], Pawn, 'black')}
      it 'returns {[4, 4], [4, 3]} if it hasn\'t moved' do
        result = Set[[4, 4], [4, 3]]
        expect(@chess_board[[4, 5]].piece.black_moves).to eq(result)
      end
      it 'returns {[4, 4]} if it has moved' do
        @chess_board[[4, 5]].piece.moved = true
        result = Set[[4, 4]]
        expect(@chess_board[[4, 5]].piece.black_moves).to eq(result)
      end
    end

    context 'When there is a piece [3, 5] and a friendly piece on [3, 4]' do
      it 'returns an empty set' do
      @chess_board.add_piece([3, 5], Pawn, 'black')
      @chess_board.add_piece([3, 4], Pawn, 'black')
      result = Set.new
      expect(@chess_board[[3, 5]].piece.black_moves).to eq(result)
      end
    end

    context 'When there is a piece on [3, 5] and an enemy piece on [3, 3]' do
      it 'returns in {[3, 4]}' do
        @chess_board.add_piece([3, 5], Pawn, 'back')
        @chess_board.add_piece([3, 3], Pawn, 'white')
        result = Set[[3, 4]]
        expect(@chess_board[[3, 5]].piece.black_moves).to eq(result)
      end
    end

    context 'When there is a piece on [5, 1]' do
      it 'returns {[5, 0]}' do
        @chess_board.add_piece([5, 1], Pawn, 'black')
        results = Set[[5, 0]]
        expect(@chess_board[[5, 1]].piece.black_moves).to eq(results)
      end
    end
  end

  describe '#p_white_capture_moves' do
    before(:each) {@chess_board.add_piece([0, 0], Pawn, 'white')}

    context 'Pawn on [0, 0]' do
      it 'returns [1, 1] with no enemy piece and enemy piece there' do
        result = Set[[1, 1]]
        expect(@chess_board[[0, 0]].piece.p_white_capture_moves).to eq(result)
        @chess_board.add_piece([1, 1], Pawn, 'black')
        expect(@chess_board[[0, 0]].piece.p_white_capture_moves).to eq(result)
      end

    end

    describe '#p_black_capture_moves' do
      before(:each) {@chess_board.add_piece([5, 5], Pawn, 'black') }

      context 'Pawn on [5, 5]' do
        it 'returns a set with [4, 4] and [6, 4] with no pieces and pieces on the board' do
          result = Set[[4, 4], [6, 4]]
          expect(@chess_board[[5, 5]].piece.p_black_capture_moves).to eq(result)
          @chess_board.add_piece([4, 4], Pawn, 'white')
          @chess_board.add_piece([6, 4], Pawn, 'black')
          expect(@chess_board[[5, 5]].piece.p_black_capture_moves).to eq(result)
        end
      end
    end
  end

  describe '#add_en_passant_move' do
    before(:each) do
      @board = ChessBoard.new
      @board.add_piece([3, 3], Pawn, 'white')
      @board.add_piece([4, 3], Pawn, 'white')
      @board.add_piece([2, 3], Pawn, 'black')
      @board.update_all_pieces
    end

    it 'gives the correct attack move a black pawn and it gives no move to a white pawn ' do
      @board[[3, 3]].piece.possible_en_passant = true
      @board.update_all_pieces
      expect(@board[[4, 3]].piece.possible_moves).not_to include([3, 2])
      expect(@board[[2, 3]].piece.possible_moves).to include([3, 2])
    end

    it 'gives the correct attack move a white pawn' do
      @board[[2, 3]].piece.possible_en_passant = true
      @board.update_all_pieces
      expect(@board[[3, 3]].piece.possible_moves).to include([2, 4])
    end
  end

  describe '#dump_json & #load_json' do
    it 'creates a new pawn with instance variables of the same value' do
      board = ChessBoard.new
      board.add_piece([0, 0], Pawn, 'black')
      old_pawn = board[[0, 0]].piece
      board.add_piece([1, 0], Pawn, 'white')
      board[[1, 0]].piece.possible_en_passant = true
      board.update_all_pieces
      string = board[[0, 0]].piece.dump_json
      new_pawn = Pawn.load_json(string, board)

      # Every instance variable in both pawns have to match
      expect(new_pawn.team).to eq(old_pawn.team)
      expect(new_pawn.coordinates).to eq(old_pawn.coordinates)
      expect(new_pawn.moved).to eq(old_pawn.moved)
      expect(new_pawn.p_capture_moves).to eq(old_pawn.p_capture_moves)
      expect(new_pawn.en_passant_attk).to eq(old_pawn.en_passant_attk)
      expect(new_pawn.possible_en_passant).to eq(old_pawn.possible_en_passant)
      expect(new_pawn.possible_moves).to eq(old_pawn.possible_moves)

    end

  end
end
