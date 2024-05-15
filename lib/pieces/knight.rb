# frozen_string_literal: true

require_relative '../piece'

# A knight class for Chessboard
class Knight < Piece
  attr_accessor :symbol

  def initialize(team, board, coordinates)
    super(team, board, coordinates)
    @symbol = team == 'white' ? '♘'.black : '♞'.black
  end

  # These moves should not be as complicated as the moves for the other classes
  def update_possible_moves
    x = @coordinates[0]
    y = @coordinates[1]
    jumping_squares = [[x + 1, y + 2], [x + 2, y + 1], [x + 1, y - 2], [x + 2, y - 1],  [x - 1, y - 2], [x - 2, y - 1], [x - 1, y + 2], [x - 2, y + 1]]
    @possible_moves = Set.new
    # Add the jump if they are in the board and there is either a an enemy piece there or no piece at all
    jumping_squares.each do |coord|
      @possible_moves.add(coord) if !out_of_bounds?(coord) && (board[coord].piece.nil? || possible_capture?(coord))
    end
  end
end
