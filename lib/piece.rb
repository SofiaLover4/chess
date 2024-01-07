# frozen_string_literal: true

# A foundation for all the chess pieces
class Piece
  attr_accessor :team, :board, :coordinates

  def initialize(team, board, coordinates)
    @team = team
    @board = board
    @coordinates = coordinates
  end

  def out_of_bounds?(coordinates)
    x = coordinates[0]
    y = coordinates[1]

    x < 0 || x > 7 || y < 0 || y > 7
  end
end
