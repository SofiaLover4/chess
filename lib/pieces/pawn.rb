# frozen_string_literal: true

require_relative '../piece'
require_relative '../board'

# Pawn class for Chessboard
class Pawn < Piece
  attr_accessor :symbol
  attr_writer :moved

  def initialize(team, board, coordinates)
    super(team, board, coordinates)
    @symbol = if team == 'white'
                '♙'.black
              elsif team == 'black'
                '♟︎'.black
              end
    @moved = false
    update_possible_moves
  end

  # Because a Pawn can only move twice if they haven't moved yet
  def moved?
    @moved
  end

  def update_possible_moves
    @possible_moves = Set.new
    if @team == 'white'
      @possible_moves.merge(white_moves).merge(white_capture_moves)
    else # There are only ever two teams
      @possible_moves.merge(black_moves).merge(black_capture_moves)
    end
  end

  def possible_capture?(coordinates)
    !(out_of_bounds?(coordinates) || @board[coordinates].piece.nil? || @board[coordinates].piece.team == @team)
  end

  def white_capture_moves
    capture_moves = Set.new
    x = @coordinates[0]
    y = @coordinates[1]

    capture_moves << [x - 1, y + 1] if possible_capture?([x - 1, y + 1])
    capture_moves << [x + 1, y + 1] if possible_capture?([x + 1, y + 1])

    capture_moves
  end

  def white_moves
    moves = Set.new
    x = @coordinates[0]
    y = @coordinates[1]
    forward_spaces = moved? ? 1 : 2 # If the pawn has moved it can only move one space ahead else
    forward_spaces.times do
      y += 1
      break if out_of_bounds?([x, y]) || !@board[[x, y]].piece.nil?

      moves << [x, y]
    end

    moves
  end

  def black_capture_moves
    capture_moves = Set.new
    x = @coordinates[0]
    y = @coordinates[1]

    capture_moves << [x - 1, y - 1] if possible_capture?([x - 1, y - 1])
    capture_moves << [x + 1, y - 1] if possible_capture?([x + 1, y - 1])

    capture_moves
  end

  def black_moves
    moves = Set.new
    x = @coordinates[0]
    y = @coordinates[1]
    forward_spaces = moved? ? 1 : 2
    forward_spaces.times do
      y -= 1
      break if out_of_bounds?([x, y]) || !@board[[x, y]].piece.nil?

      moves << [x, y]
    end

    moves
  end
end
