# frozen_string_literal: true

# A foundation for all the chess pieces
class Piece
  attr_accessor :team, :board, :coordinates

  def initialize(team, board, coordinates)
    @team = team
    @board = board
    @coordinates = coordinates
    @possible_moves = nil
  end

  def out_of_bounds?(coordinates)
    x = coordinates[0]
    y = coordinates[1]

    x < 0 || x > 7 || y < 0 || y > 7
  end

  def possible_moves(&block)
    if block_given?
      @possible_moves.each { |move| block.call(move) } # Will be used to show possible moves on the board
    else
      @possible_moves
    end
  end

  def possible_capture?(coordinates)
    @board[coordinates].piece.team != @team
  end

end
