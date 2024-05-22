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
    DiagonalMoves.instance_methods(false).each do |method|
      @possible_moves.merge(send(method, self))
    end
  end


end