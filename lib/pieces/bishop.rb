# frozen_string_literal: true

require_relative '../piece'
require_relative './generic_moves/diagonal_moves'

# Bishop class for Chessboard
class Bishop < Piece
  attr_accessor :symbol, :board

  include DiagonalMoves

  def initialize(team, board, coordinates)
    super(team, board, coordinates)
    @symbol = team == 'white' ? '♗'.black  : '♝'.black

  end

  def update_possible_moves
    # The moves are the same no matter the team
    @possible_moves = Set.new
    @possible_moves.merge(right_moves(self)).merge(left_moves(self)).merge(forward_moves(self)).merge(back_moves(self))
  end


end