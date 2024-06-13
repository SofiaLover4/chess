# frozen_string_literal: true

require_relative '../piece'

# Pawn class for Chessboard
class Pawn < Piece
  attr_accessor :symbol, :capture_moves, :p_capture_moves, :en_passant_attk
  attr_writer :moved

  def initialize(team, board, coordinates)
    super(team, board, coordinates)
    @symbol = team == 'white' ? '♙'.black : '♟︎'.black
    @p_capture_moves = nil
    @en_passant_attk = nil
    @moved = false
  end

  # Because a Pawn can only move twice if they haven't moved yet
  def moved?
    @moved
  end

  def update_possible_moves
    @possible_moves = Set.new
    @p_capture_moves = Set.new
    @en_passant_attk = nil
    if @team == 'white'
      @p_capture_moves = p_white_capture_moves
      @possible_moves.merge(white_moves).merge(white_capture_moves)
    else # There are only ever two teams
      @p_capture_moves = p_black_capture_moves
      @possible_moves.merge(black_moves).merge(black_capture_moves)
    end
  end

  # # This method overwrites the possible_capture? method in the Piece class because pawns are a little different
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

  # For situations where a piece moves to the diagonal of Pawn and risks getting captured. This is mostly to make sure
  # that the King can't do this
  def p_white_capture_moves
    p_capture_moves = Set.new
    x = @coordinates[0]
    y = @coordinates[1]

    p_capture_moves << [x - 1, y + 1] if !out_of_bounds?([x - 1, y + 1])
    p_capture_moves << [x + 1, y + 1] if !out_of_bounds?([x + 1, y + 1])

    p_capture_moves
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

  def p_black_capture_moves
    p_capture_moves = Set.new
    x = @coordinates[0]
    y = @coordinates[1]

    p_capture_moves << [x - 1, y - 1] if !out_of_bounds?([x - 1, y - 1])
    p_capture_moves << [x + 1, y - 1] if !out_of_bounds?([x + 1, y - 1])

    p_capture_moves
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

  # Should be used after a Pawn is moved and it is left open for en passant. Method updates the possible moves of adjacent enemy pawns to include the square where an en passant can take place.
  def add_en_passant_move
    x = @coordinates[0]
    y = @coordinates[1]

    attack_square = @team == 'white' ? [x, y - 1] : [x, y + 1]

    if !out_of_bounds?([x - 1, y]) && @board[[x - 1, y]].piece? && @board[[x - 1, y]].piece.team != @team && @board[[x - 1, y]].piece.is_a?(Pawn)
      @board[[x - 1, y]].piece.en_passant_attk = attack_square
      @board[[x - 1, y]].piece.possible_moves.add(attack_square)
    end
    if !out_of_bounds?([x - 1, y]) && @board[[x + 1, y]].piece? && @board[[x + 1, y]].piece.team != @team && @board[[x + 1, y]].piece.is_a?(Pawn)
      @board[[x + 1, y]].piece.en_passant_attk = attack_square
      @board[[x + 1, y]].piece.possible_moves.add(attack_square)
    end

  end
end
