# frozen_string_literal: true


require_relative '../../lib/pieces/bishop'
require_relative '../../lib/board'

# These tests are going to be similar to the Rook tests in that it's going to be testing the module
# DiagonalMoves more than the piece itself. This should be the last test that looks like this

describe Bishop do
  before(:each) do
    @chess_board = ChessBoard.new
  end

  describe "#right_diag_up" do
    context "When bishop is on [1, 2]" do
      before(:each) do
        @chess_board.add_piece([1, 2], Bishop, 'white')
        @target_piece = @chess_board[[1, 2]].piece
      end

      it 'returns a set with [2, 3]...[6, 7] with no blocking piece' do
        result = Set[[2, 3], [3, 4], [4, 5], [5, 6], [6, 7]]
        expect(@target_piece.right_diag_up(@target_piece)).to eq(result)
      end

      it 'returns a set with [2, 3]...[4, 5] with a block friendly piece' do
        @chess_board.add_piece([5, 6], Bishop, 'white')
        result = Set[[2, 3], [3, 4], [4, 5]]
        expect(@target_piece.right_diag_up(@target_piece)).to eq(result)
      end

      it 'returns a set with [2, 3]...[5, 6] with a blocking enemy piece' do
        @chess_board.add_piece([5, 6], Bishop, 'black')
        result = Set[[2, 3], [3, 4], [4, 5], [5, 6]]
        expect(@target_piece.right_diag_up(@target_piece)).to eq(result)
      end
    end
  end

  describe '#left_diag_up' do
    context 'When bishop is on [5, 2]' do
      before(:each) do
        @chess_board.add_piece([5, 2], Bishop, 'black')
        @target_piece = @chess_board[[5, 2]].piece
      end

      it 'returns a set with [4, 3]...[0, 7] with no blocking piece' do
        result = Set[[4, 3], [3, 4], [2, 5], [1, 6], [0, 7]]
        expect(@target_piece.left_diag_up(@target_piece)).to eq(result)
      end
      it 'returns a set with [4, 3]...[3, 4] with a blocking friendly piece' do
        @chess_board.add_piece([2, 5], Bishop, 'black')
        result = Set[[4, 3], [3, 4]]
        expect(@target_piece.left_diag_up(@target_piece)).to eq(result)
      end
      it 'returns a set with [4, 3]...[2, 5] with a blocking enemy piece' do
        @chess_board.add_piece([2, 5], Bishop, 'white')
        result = Set[[4, 3], [3, 4], [2, 5]]
        expect(@target_piece.left_diag_up(@target_piece)).to eq(result)
      end
    end
  end

  describe '#right_diag_down' do
    context 'When bishop is on [3, 4]' do
      before(:each) do
        @chess_board.add_piece([3, 4], Bishop, 'white')
        @target_piece = @chess_board[[3, 4]].piece
      end

      it 'returns a set with [4, 3]..[7, 0]' do
        result = Set[[4, 3], [5, 2], [6, 1], [7, 0]]
        expect(@target_piece.right_diag_down(@target_piece)).to eq(result)
      end
      it 'returns a set with [4, 3] with a blocking friendly piece' do
        @chess_board.add_piece([5, 2], Bishop, 'white')
        result = Set[[4, 3]]
        expect(@target_piece.right_diag_down(@target_piece)).to eq(result)
      end
      it 'returns a set with [4, 3]...[5,2] with a blocking enemy piece' do
        @chess_board.add_piece([5, 2], Bishop, 'black')
        result = Set[[4, 3], [5, 2]]
        expect(@target_piece.right_diag_down(@target_piece)).to eq(result)
      end
    end
  end

  describe '#left_diag_down' do
    context 'When there is a piece on [6, 6]' do
      before(:each) do
        @chess_board.add_piece([6, 6], Bishop, 'black')
        @target_piece = @chess_board[[6, 6]].piece
      end

      it 'returns a set with [5, 5]...[0, 0]' do
        result = Set[[5, 5], [4, 4], [3, 3], [2, 2], [1, 1], [0, 0]]
        expect(@target_piece.left_diag_down(@target_piece)).to eq(result)
      end

      it 'returns a set with [5, 5]...[4, 4] with a blocking friendly piece' do
        @chess_board.add_piece([3,3], Bishop, 'black')
        result = Set[[5, 5], [4, 4]]
        expect(@target_piece.left_diag_down(@target_piece)).to eq(result)
      end

      it 'returns a set with [5, 5]...[4, 4] with a blocking friendly piece' do
        @chess_board.add_piece([3,3], Bishop, 'white')
        result = Set[[5, 5], [4, 4], [3, 3]]
        expect(@target_piece.left_diag_down(@target_piece)).to eq(result)
      end
    end

  end
end