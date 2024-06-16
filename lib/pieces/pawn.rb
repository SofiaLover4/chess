# frozen_string_literal: true

require_relative '../piece'
require 'json'

# Pawn class for Chessboard
class Pawn < Piece
  attr_accessor :symbol, :p_capture_moves, :en_passant_attk, :possible_en_passant, :moved

  def initialize(team, board, coordinates)
    super(team, board, coordinates)
    @symbol = team == 'white' ? '♙'.black : '♟︎'.black
    @p_capture_moves = Set.new
    @en_passant_attk = nil
    @moved = false
    @possible_en_passant = false
  end

  # Because a Pawn can only move twice if they haven't moved yet
  def moved?
    @moved
  end

  def update_possible_moves
    @possible_moves = Set.new
    @p_capture_moves = Set.new
    add_en_passant_move
    if @team == 'white'
      @p_capture_moves = p_white_capture_moves
      @possible_moves.merge(white_moves).merge(white_capture_moves)
    else # There are only ever two teams
      @p_capture_moves = p_black_capture_moves
      @possible_moves.merge(black_moves).merge(black_capture_moves)
    end
    @possible_moves.add(@en_passant_attk) unless @en_passant_attk.nil?
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
    @en_passant_attk = nil

    row_move = @team == 'white' ? 1 : -1 # Letting the method know which direction to move based on the team
    left = [x - 1, y]
    right = [x + 1, y]

    if !out_of_bounds?(left) && @board[left].piece? && @board[left].piece.team != @team && @board[left].piece.is_a?(Pawn) && @board[left].piece.possible_en_passant
      @en_passant_attk = [x - 1, y + row_move] unless out_of_bounds?([x - 1, y + row_move])
    end
    if !out_of_bounds?(right) && @board[right].piece? && @board[right].piece.team != @team && @board[right].piece.is_a?(Pawn) && @board[right].piece.possible_en_passant
      @en_passant_attk = [x + 1, y + row_move] unless out_of_bounds?([x + 1, y + row_move])
    end
  end

  def dump_json
    # Notice the board isn't being dumped here. Be careful when loading from JSON
    {
      'team' => @team,
      'coordinates' => @coordinates,
      'moved' => @moved,
      'p_capture_moves' => @p_capture_moves.to_a,
      'en_passant_attk' => @en_passant_attk,
      'possible_en_passant' => @possible_en_passant,
      'possible_moves' => @possible_moves.to_a
    }.to_json
  end

  def self.load_json(json_string, board) # A board will be needed upon loading a Pawn from JSON
    data = JSON.parse(json_string)
    new_pawn = self.new(data['team'], board, data['coordinates'])
    new_pawn.moved = data['moved']
    new_pawn.p_capture_moves = Set.new(data['p_capture_moves'])
    new_pawn.en_passant_attk = data['en_passant_attk']
    new_pawn.possible_en_passant = data['possible_en_passant']
    new_pawn.possible_moves = Set.new(data['possible_moves'])

    new_pawn
    # Note: The pawn is not added to the board after this.
  end

end
