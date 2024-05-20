# frozen_string_literal: true

require_relative '../piece'

# King piece for Chessboard
class King < Piece
  attr_accessor :symbol

  def initialize(team, board, coordinates)
    super(team, board, coordinates)
    @symbol = team == 'white' ? '♔'.black : '♚'.black
    @moved = false
  end

  def moved?
    @moved
  end

  def update_possible_moves
    # This method should be similar to the knights #update_possible_moves
    x = coordinates[0]
    y = coordinates[1]
    jumping_squares = [[x, y + 1], [x, y - 1], [x - 1, y], [x + 1, y],
                       [x + 1,  y + 1], [x - 1, y + 1], [x + 1, y - 1], [x - 1, y - 1]]
    @possible_moves = Set.new
    jumping_squares.each do |coord|
      @possible_moves.add(coord) if !out_of_bounds?(coord) && (board[coord].piece.nil? || possible_capture?(coord))
    end
  end
end