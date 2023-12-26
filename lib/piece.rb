# frozen_string_literal: true

# A foundation for all the chess pieces
class Piece
  attr_accessor :team, :symbol, :coordinates, :possible_moves

  def initialize(team, coordinates)
    @team = team
    @coordinates = coordinates
  end
end
