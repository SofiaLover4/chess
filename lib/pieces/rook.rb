# frozen_string_literal: true

require_relative '../piece'
require_relative './generic_moves/cross_moves'

# Rook class for Chessboard
class Rook < Piece
  attr_accessor :symbol, :board, :moved

  include CrossMoves
  def initialize(team, board, coordinates)
    super(team, board, coordinates)
    @symbol = team == 'white' ? '♖'.black : '♜'.black
    @moved = false
  end

  def moved?
    @moved
  end

  def update_possible_moves
    # The moves are the same no matter the team
    @possible_moves = Set.new
    CrossMoves.instance_methods(false).each do |method|
      @possible_moves.merge(send(method, self))
    end
  end

end
