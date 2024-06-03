# frozen_string_literal: true
require_relative 'board'

# This class will be handling all the logic of chess
class ChessLogic

  attr_accessor :board

  def initialize
    @board = ChessBoard.new
  end

  def square_under_attack?(coordinates, team)
    # Choose which set of pieces in play
    pieces_in_play = team == 'white' ? @board.black_in_play : @board.white_in_play

    pieces_in_play.each do |piece|
      if piece.is_a?(Pawn) # This problem with this is that there's actually nothing in the square so you are gonna have to update this tomorrow
        return true if piece.p_capture_moves.include?(coordinates)
      elsif piece.possible_moves.include?(coordinates)
        # For all other pieces that are not pawns
        return true
      end
    end

    false
  end

  def valid_move?(start_coord, end_coord)
    # Should not have to worry about out of bounds errors, I am planning to make sure the user can only input
    # valid board coordinates. This should run after user has selected a piece.

    piece = @board[start_coord].piece
    # The move should be in the piece's range and the move should be a valid hypothetical move i.e it doesn't put the
    # king in check

    if piece.possible_moves.include?(end_coord)
      if piece.team == 'white'
        return valid_hypothetical_move?(start_coord, end_coord, 'white',@board.black_in_play, @board.black_out)
      else
        return valid_hypothetical_move?(start_coord, end_coord, 'black',@board.white_in_play, @board.white_out)
      end
    end

    false
  end

  # Parameter should only be a King piece
  def in_check?(team)
    # Both Kings will have to be loaded on the board
    king = team == 'white' ? @board.white_king : @board.black_king
    square_under_attack?(king.coordinates, team)
  end

  def pinned?(piece)
    # The set up
    team = piece.team
    outset = team == 'white' ? @board.white_out : @board.black_out
    enemy_in_play = team == 'white' ? @board.black_in_play : @board.white_in_play
    start = piece.coordinates

    # Here we are going to be doing a lot of hypotheticals 'if the piece moved here would the king still be in check?'
    piece.possible_moves do |move_coordinates|
      # "if the king wouldn't be in check then there is a hypothetical move"
      return false if valid_hypothetical_move?(start, move_coordinates, team, enemy_in_play, outset)
    end

    # NOTE: This returns true if all the moves the piece can make result in the king being in check but
    # it also returns true if the piece has not possible moves. I guess it still is pinned because it can't move
    true
  end

  # The argument is the team being checked for a stalemate
  def stale_mate?(team)
    # Choose which pieces in play you are checking
    pieces_in_play = team == 'white' ? @board.white_in_play : @board.black_in_play
    return false if in_check?(team) # King can't in check for a stalemate

    pieces_in_play.each do |piece|
      piece.possible_moves.each do |move|
        return false if valid_move?(piece.coordinates, move)
      end
    end

    true
  end

  # Argument is the team you want to verify check_mate for
  def check_mate?(team)
    # Checkmate logic should be fairly similar to stalemate logic, only difference is that the king has to be in check
    pieces_in_play = team == 'white' ? @board.white_in_play : @board.black_in_play

    return false unless in_check?(team)

    pieces_in_play.each do |piece|
      piece.possible_moves.each do |move|
        return false if valid_move?(piece.coordinates, move)
      end
    end

    true
  end

  private

  # A helper method. Returns true if the king is NOT in check if you make the hypothetical move,
  # else false.
  def valid_hypothetical_move?(start, move_coordinates, team, enemy_in_play, outset)
    # Board should be the same after the method has run its course
    tmp = @board[move_coordinates].piece

    # moving {
    @board.move_piece(start, move_coordinates) # Do the move
    enemy_in_play.each { |piece| piece.update_possible_moves }
    checked = !in_check?(team)
    @board.move_piece(move_coordinates, start) # undo the move
    # } moving

    outset.delete?(tmp)
    @board.add_piece(tmp.coordinates, tmp.class, tmp.team) unless tmp.nil? # If you did take out a piece add it back in
    enemy_in_play.each { |piece| piece.update_possible_moves }
    checked
  end


end
