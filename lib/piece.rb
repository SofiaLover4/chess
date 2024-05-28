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

  # Doesn't directly check if the piece is under attack but it allows a piece
  # to check ANY squares that are under attack from the enemy team.
  def square_under_attack?(coordinates)
    # Choose which set of pieces in play
    pieces_in_play = team == 'white' ? @board.black_in_play : @board.white_in_play

    pieces_in_play.each do |piece|
       if piece.is_a?(Pawn)
         return true if piece.capture_moves.include?(coordinates)
       elsif piece.possible_moves.include?(coordinates)
         # For all other pieces that are not pawns
         return true
       end
    end

    false
    end
end
