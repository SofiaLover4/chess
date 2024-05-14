# frozen_string_literal: true

require_relative '../piece'
require_relative '../board'
require_relative './generic_moves/diagonal_moves'

# Bishop class for Chessboard
class Bishop < Piece
  attr_accessor :symbol, :board

  include DiagonalMoves

  def initialize(team, board, coordinates)
    super(team, board, coordinates)
    @symbol = if team == 'white'
                '♗'.black
              elsif team == 'black'
                '♝'.black
              end
  end

  def update_possible_moves
    # The moves are the same no matter the team
    @possible_moves = Set.new
    @possible_moves.merge(right_moves(self)).merge(left_moves(self)).merge(forward_moves(self)).merge(back_moves(self))
  end

  def possible_capture?(coordinates)
    @board[coordinates].piece.team != @team
  end

end