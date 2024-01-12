# frozen_string_literal: true

require_relative '../piece'
require_relative '../board'

# Rook class for Chessboard
class Rook < Piece
  attr_accessor :symbol, :board

  def initialize(team, board, coordinates)
    super(team, board, coordinates)
    @symbol = if team == 'white'
                '♜'
              elsif team == 'black'
                '♜'.grey
              end
    @moved = false
    update_possible_moves
  end

  def moved?
    @moved
  end

  def update_possible_moves
    # The moves are the same no matter the team
    @possible_moves = Set.new
    @possible_moves.merge(right_moves).merge(left_moves).merge(forward_moves).merge(back_moves)
  end

  def possible_capture?(coordinates)
    @board[coordinates].piece.team != @team
  end

  def right_moves
    moves = Set.new
    x = @coordinates[0] + 1
    y = @coordinates[1]
    until out_of_bounds?([x, y])
      unless @board[[x, y]].piece.nil?
        moves << [x, y] if possible_capture?([x, y])

        break
      end
      moves << [x, y]
      x += 1
    end
    moves
  end

  def left_moves
    moves = Set.new
    x = @coordinates[0] - 1
    y = @coordinates[1]

    until out_of_bounds?([x, y])
      unless @board[[x, y]].piece.nil?
        moves << [x, y] if possible_capture?([x, y])

        break
      end

      moves << [x, y]
      x -= 1
    end
    moves
  end

  def forward_moves
    moves = Set.new
    x = @coordinates[0]
    y = @coordinates[1] + 1

    until out_of_bounds?([x, y])
      unless @board[[x, y]].piece.nil?
        moves << [x, y] if possible_capture?([x, y])

        break
      end

      moves << [x, y]
      y += 1
    end
    moves
  end

  def back_moves
    moves = Set.new
    x = @coordinates[0]
    y = @coordinates[1] - 1

    until out_of_bounds?([x, y])
      unless @board[[x, y]].piece.nil?
        moves << [x, y] if possible_capture?([x, y])
        break
      end

      moves << [x, y]
      y -= 1
    end
    moves
  end
end
