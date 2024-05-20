# frozen_string_literal: true

require_relative '../piece'
Dir["#{File.dirname(__FILE__)}/generic_moves/*.rb"].each do |file|
  require_relative file
end

# Queen piece for Chessboard
class Queen < Piece
  attr_accessor :symbol, :board

  include CrossMoves
  include DiagonalMoves

  def initialize(team, board, coordinates)
    super(team, board, coordinates)
    @symbol = team == 'white' ? '♕'.black : '♛'.black

  end

  def update_possible_moves
    @possible_moves = Set.new
    CrossMoves.instance_methods(false).each do |method|
      @possible_moves.merge(send(method, self))
    end
    DiagonalMoves.instance_methods(false).each do |method|
      @possible_moves.merge(send(method, self))
    end
  end
end
