# frozen_string_literal: true
require_relative 'board'

# This class will be handling all the logic of chess
class ChessLogic

  attr_accessor :board

  def initialize
    @board = ChessBoard.new
  end

  def square_under_attack?(coordinates, team)
    # Choose which set of pieces in play
    pieces_in_play = team == 'white' ? @board.black_in_play : @board.white_in_play

    pieces_in_play.each do |piece|
      if piece.is_a?(Pawn) # This problem with this is that there's actually nothing int eh square so you are gonna have to update this tomorrow
        return true if piece.p_capture_moves.include?(coordinates)
      elsif piece.possible_moves.include?(coordinates)
        # For all other pieces that are not pawns
        return true
      end
    end

    false
  end

  def valid_move?(start_coord, end_coord)
    # Should not have to worry about out of bounds errors, I am planning to make sure the user can only input
    # valid board coordinates.
    if @board[start_coord].piece?
      if @board[start_coord].piece.is_a?(King)
        return true if @board[start_coord].piece.possible_moves.include?(end_coord) && !square_under_attack?(end_coord, @board[start_coord].piece.team)
      else
        return true if @board[start_coord].piece? && @board[start_coord].piece.possible_moves.include?(end_coord)
      end
    end

    false
  end

end
