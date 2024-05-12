# frozen_string_literal: true

require_relative '../../lib/pieces/rook'
require_relative '../../lib/pieces/pawn'
require_relative '../../lib/board'

# These tests were written before I moved the rook methods into their own
# module for simpler future code. As a result these tests are testing the module
# and the rook class. Future tests will not look like this

describe Rook do
  before(:each) do
    @chess_board = ChessBoard.new
  end

  describe '#right_moves' do
    before(:each) do
      @chess_board.add_piece([1, 1], Rook, 'white')
      @target_piece = @chess_board[[1, 1]].piece
    end
    context 'When rook is on [1, 1] with no blocking pieces' do
      it 'returns a set containing squares [2, 1]...[7, 1]' do
        result = Set[[2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1]]
        expect(@target_piece.right_moves(@target_piece)).to eq(result)
      end
    end

    context 'When rook is on [1, 1] with an enemy piece on [5, 1]' do
      it 'returns a set containing squares [2, 1]...[5, 1]' do
        @chess_board.add_piece([5, 1], Rook, 'black')
        result = Set[[2, 1], [3, 1], [4, 1], [5, 1]]
        expect(@target_piece.right_moves(@target_piece)).to eq(result)
      end
    end

    context 'When rook is on [1, 1] with a friendly piece on [5, 1]' do
      it 'returns a set containing squares [2, 1]...[4, 1]' do
        @chess_board.add_piece([5, 1], Pawn, 'white')
        result = Set[[2, 1], [3, 1], [4, 1]]
        expect(@target_piece.right_moves(@target_piece)).to eq(result)
      end
    end
  end

  describe '#left_moves' do
    before(:each) do
      @chess_board.add_piece([5, 3], Rook, 'black')
      @target_piece = @chess_board[[5, 3]].piece
    end
    context 'When rook is on [5, 3] with no blocking pieces' do
      it 'returns a set containing squares [0, 3]...[4, 3]' do

        result = Set[[0, 3], [1, 3], [2, 3], [3, 3], [4, 3]]
        expect(@target_piece.left_moves(@target_piece)).to eq(result)
      end
    end

    context 'When rook is on [5, 3] with an enemy piece on [3, 3]' do
      it 'returns a set containing [3, 3]...[4, 3]' do
        @chess_board.add_piece([3, 3], Rook, 'white')
        result = Set[[3, 3], [4, 3]]
        expect(@target_piece.left_moves(@target_piece)).to eq(result)
      end
    end

    context 'When rook is on [5, 3] with a friendly piece on [3, 3]' do
      it 'returns a set with [4, 3]' do
        @chess_board.add_piece([3, 3], Rook, 'black')
        result = Set[[4, 3]]
        expect(@target_piece.left_moves(@target_piece)).to eq(result)
      end
    end
  end

  describe '#forward_moves' do
    before(:each) do
      @chess_board.add_piece([5, 0], Rook, 'white')
      @target_piece = @chess_board[[5, 0]].piece
    end
    context 'When rook is on [5, 0] with no blocking pieces' do
      it 'returns a set with [5, 1]...[5, 7]' do
        result = Set[[5, 1], [5, 2], [5, 3], [5, 4], [5, 5], [5, 6], [5, 7]]
        expect(@target_piece.forward_moves(@target_piece)).to eq(result)
      end
    end

    context 'When rook is on [5, 0] with an enemy piece on [5, 1]' do
      it 'returns a set with [5, 1]' do
        @chess_board.add_piece([5, 1], Pawn, 'black')
        result = Set[[5, 1]]
        expect(@target_piece.forward_moves(@target_piece)).to eq(result)
      end
    end

    context 'When rook is on [5, 0] with a friendly piece on [5, 1]' do
      it 'returns an empty set' do
        @chess_board.add_piece([5, 1], Pawn, 'white')
        result = Set.new
        expect(@target_piece.forward_moves(@target_piece)).to eq(result)
      end
    end
  end

  describe '#back_moves' do
    before(:each) do
      @chess_board.add_piece([5, 4], Rook, 'black')
      @target_piece = @chess_board[[5, 4]].piece
    end
    context 'When rook is on [5, 4] with no blocking pieces' do
      it 'returns a set containing [5, 3]...[5, 0]' do
        result = Set[[5, 3], [5, 2], [5, 1], [5, 0]]
        expect(@target_piece.back_moves(@target_piece)).to eq(result)
      end
    end

    context 'When rook is on [5, 4] with an enemy piece on [5, 0]' do
      it 'returns a set containing [5, 3]...[5, 0]' do
        @chess_board.add_piece([5, 0], Pawn, 'white')
        result = Set[[5, 3], [5, 2], [5, 1], [5, 0]]
        expect(@target_piece.back_moves(@target_piece)).to eq(result)
      end
    end

    context 'When rook is on [5, 4] with an friendly piece on [5, 2]' do
      it 'returns a set containing [5, 3]' do
        @chess_board.add_piece([5, 2], Pawn, 'black')
        result = Set[[5, 3]]
        expect(@target_piece.back_moves(@target_piece)).to eq(result)
      end
    end
  end
end
