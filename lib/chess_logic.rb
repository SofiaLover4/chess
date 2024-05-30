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
    # valid board coordinates.
    if @board[start_coord].piece?
      if @board[start_coord].piece.is_a?(King)
        return true if @board[start_coord].piece.possible_moves.include?(end_coord) && !square_under_attack?(end_coord, @board[start_coord].piece.team)
      else
        return true if @board[start_coord].piece? && @board[start_coord].piece.possible_moves.include?(end_coord)
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

  # and if the king is in check mate

  private

  # A helper method for the #pinned? method. Returns true if the king is NOT in check if you make the hypothetical move,
  # else false.
  def valid_hypothetical_move?(start, move_coordinates, team, enemy_in_play, outset)
    # Board should be the same after the method has run its course
    tmp = @board[move_coordinates].piece

    # moving {
    @board.move_piece(start, move_coordinates) # Do the move
    enemy_in_play.each { |piece| piece.update_possible_moves }
    checked = !in_check?(team)
    @board.move_piece(move_coordinates, start) # undo the move
    enemy_in_play.each { |piece| piece.update_possible_moves }
    # } moving

    outset.delete?(tmp)
    @board.add_piece(tmp.coordinates, tmp.class, tmp.team) unless tmp.nil? # If you did take out a piece add it back in
    checked
  end


end
