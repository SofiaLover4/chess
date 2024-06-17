# frozen_string_literal: true

require_relative 'board'
require_relative 'chess_logic'
require 'json'
require 'date'

# Where the actual chessGame will be played and the menus
class GamePlay
  attr_accessor :current_team, :game_over, :message, :file

  def valid_user_coord?(user_input)
    # If the user is trying to select a space on the board, the string must be 2 long with the first character
    # being a letter from a - h and the second character being an sting type integer from 1 - 8.
    # Ord is converting the strings into integers and making sure they fit in their appropriate ranges
    user_input.length == 2 && (97..104).include?(user_input[0].ord) && (49..56).include?(user_input[1].ord)
  end

  # Takes in user input and converts it too coordinates for the board
  def translate(user_input)
    chess_dict = { a: 0, b: 1, c: 2, d: 3, e: 4, f: 5, g: 6, h: 7 }
    8.times { |number| chess_dict[(number + 1).to_s] = number }

    [chess_dict[user_input[0].to_sym], chess_dict[user_input[1]]] # Returning the translated coordinate
  end
  def initialize(board: ChessBoard.new(play: true), file: nil)
    @board = board
    @logic = ChessLogic.new(board: board) # Yeah this is some wierd annoying variable naming
    @current_team = 'white'
    @message = nil # For methods that want to give the user a message
    @game_over = false
    @file = file
  end

  def switch_team
    # Usually after a switch the board messages and highlighting and should be reset
    @board.clear_all_highlighting
    @message = nil
    @current_team = @current_team == 'white' ? 'black' : 'white'
    @board.update_all_pieces
    pieces_in_play = @current_team == 'white' ? @board.white_in_play : @board.black_in_play
    # So en passant is only possible immediately after the opportunity opens up
    pieces_in_play.each { |piece| piece.possible_en_passant = false if piece.is_a?(Pawn) }
  end

  def display_game
    system('clear')
    @board.show_board
    puts @message unless @message.nil?
  end

  def play_menu
    loop do
      # Check for any game things that ended the game
      end_game

      break if game_over

      @message = "Watch out #{@current_team}, you are in check!" if @logic.in_check?(@current_team)
      display_game

      print "So, #{@current_team} what will you do?(forfeit, end, m, c, s): "
      user_input = gets.chomp.downcase

      case user_input
      when 'forfeit'
        forfeit_game
        break
      when 'end'
        break
      when 'm'
        select_piece_menu
      when 'c'
        castle_menu
      when 's'
        save_game
        @message = 'Your game has been saved!'
      end
    end

    save_menu
    display_game
  end

  def forfeit_game
    @game_over = true
    @message = "This game has concluded because #{@current_team} has forfeited!"
  end

  def select_piece_menu
    original_team = @current_team
    @message = nil
    while original_team == @current_team # If current team changes it means the player made a move
      # Board cleaning
      @board.clear_all_highlighting
      display_game

      # User prompt
      print "What piece would you like to move #{@current_team}?: "
      user_coord = gets.chomp.downcase

      if user_coord == 'back' # Go back to the command menu
        @message = nil
        break
      elsif !valid_user_coord?(user_coord)
        @message = 'This is not a valid square, please try again'
      else
        selected_square = select_piece_square(user_coord)
        next if selected_square.nil? # User made a mistake when selecting a piece

        @board[selected_square].highlight_selected
        @board[selected_square].piece.possible_moves { |move| @board[move].highlight_possible_move if @logic.valid_move?(selected_square, move)}
        make_move_menu(selected_square) # Take user onto the next step of making the move with their selected piece
      end
    end
    @board.clear_all_highlighting
  end


  # This method is for the user to select the piece they want to move
  def select_piece_square(user_input)
    # Either saves a message for the user or returns the coordinates of the square the user selected
    coord = translate(user_input)
    if @board[coord].piece.nil?
      @message = 'There is no piece here, please try again'
    elsif @board[coord].piece.team != @current_team
      @message = 'You cannot a select a piece that\'s not on your team, please try again'
    else # Valid coordinates
      @message = nil # No message to give the user
      return coord
    end
    nil
  end

  # This method is for moving a piece that is already selected
  def make_move_menu(piece_square)
    piece = @board[piece_square].piece
    loop do
      display_game
      print 'Where would you like this piece to move? ' # User prompt
      move_coord = gets.chomp.downcase # Get the square the user wants to move to

      if move_coord == 'back' # The user no longer wants to move this piece
        @message = nil
        break
      end

      if !valid_user_coord?(move_coord)
        @message = 'Sorry I didn\'t get that'
      elsif @logic.valid_move?(piece_square, translate(move_coord))
        move_coord = translate(move_coord)

        # For when a pawn is moved in such a way that it is left open for an en passant {
        piece.possible_en_passant = true if @logic.open_to_en_passant?(piece, move_coord)
        # }

        # This is handling an en passant. In short terms, you move the pawn to the enemy pawn to capture it and then move
        # the pawn back to it's original square. After, you do the proper move after the if statement
        if piece.is_a?(Pawn) && move_coord == piece.en_passant_attk
          @board.move_piece(piece_square, [piece.en_passant_attk[0], piece_square[1]])
          @board.move_piece([piece.en_passant_attk[0], piece_square[1]], piece_square)
        end

        formally_move(piece_square, move_coord)

        # Promote the pawn if a pawn is moved into a promotion square {
        promotable_pawn = pawn_to_promote
        promotion_menu(promotable_pawn) unless promotable_pawn.nil?
        # }

        switch_team # Player has made a valid move, so it's no longer their turn
        break
      else
        @message = 'Sorry, but that is not a valid move'
      end
    end
  end

  def castle_menu
    castle_sides = valid_castling_sides
    row = @current_team == 'white' ? 0 : 7

    loop do
      if castle_sides.empty?
        @message = "Sorry #{@current_team} but there is no way to castle. Please select a different command."
        break
      end

      # Highlighting the King and the rooks that you can use to castle
      @board[[0, row]].highlight_selected if castle_sides.include?('q')
      @board[[7, row]].highlight_selected if castle_sides.include?('k')
      @board[[4, row]].highlight_selected

      display_game

      print "Which side would you like to castle from (#{castle_sides} or type 'back')?: "
      user_input = gets.chomp.downcase

      if user_input == 'back'
        @board.clear_all_highlighting
        @message = nil
        break
      elsif user_input == 'q' && castle_sides.include?('q')
        formally_move([4, row], [2, row])
        formally_move([0, row], [3, row])
        switch_team
        break
      elsif user_input == 'k' && castle_sides.include?('k')
        formally_move([4, row], [6, row])
        formally_move([7, row], [5, row])
        switch_team
        break
      elsif (user_input == 'k' || user_input == 'q') && !(castle_sides.include?(user_input))
        @message = "Sorry #{@current_team} but you cannot castle to this side"
      else
        @message = 'I didn\'t get that, could you try again'

      end

      @board.clear_all_highlighting

    end
  end

  def promotion_menu(pawn)
    @board.clear_all_highlighting
    coord = pawn.coordinates
    @board[coord].highlight_selected
    in_play_set = @current_team == 'white' ? @board.white_in_play : @board.black_in_play
    @message = "Congratulations #{@current_team}, you can promote this pawn! \nTo what piece would you like to promote your pawn (q, r, b, kn)?: "
    promotion_pieces = {'q' => Queen, 'r' => Rook, 'b' => Bishop, 'kn' => Knight}
    loop do # User will not be able to leave this loop until they promote a pawn
      display_game
      user_input = gets.chomp.downcase

      if promotion_pieces.include?(user_input) # switch out the pieces
        in_play_set.delete(@board[coord].piece) # Pawn should no longer be in play
        @board[coord].piece = nil # Remove the pawn
        @board.add_piece(coord, promotion_pieces[user_input], @current_team)
        puts in_play_set
        @board[coord].piece.update_possible_moves
        @message = nil
        break
      end
      @message = "Sorry I didn\'t get that. The possible pieces you can promote to is a queen, rook, bishop, or knight. \nPlease type one of the following q, r, b, kn."
    end
  end

  def save_menu
    loop do
      display_game
      puts "\e[1mWould you like to save this game before you leave(y/n)?: "
      user_input = gets.chomp.downcase

      if user_input == 'y'
        save_game
        break
      elsif user_input == 'n'
        break
      end

    end
  end

  # Method will end the game only if someone wins or draws the game
  def end_game
    if @logic.check_mate?(@current_team)
      switch_team
      @message = "CHECK MATE. Congratulations to #{@current_team}, they have won the game!!!"
      @game_over = true
    elsif @logic.stale_mate?(@current_team)
      @message = "It seems like #{@current_team} has been stalemated! This game is a draw!"
      @game_over = true
    elsif @logic.special_draw?
      @message = 'Game Over! This game has resulted in a draw!'
      @game_over = true
    end
  end

  def dump_json
    {
      'board' => @board.dump_json,
      'current_team' => @current_team,
      'message' => @message.nil? ? @message : @message.gsub(' ', '_'), # Serialization wasn't working with spaces so this was a work around
      'game_over' => @game_over
    }.to_json
  end

  def self.load_json(json_string)
    data = JSON.parse(json_string)

    loaded_game = self.new(board: ChessBoard.load_json(data['board']))
    loaded_game.current_team = data['current_team']
    loaded_game.message = data['message'].nil? ? nil : data['message'].gsub('_', ' ')
    loaded_game.game_over = data['game_over']

    loaded_game
  end

  private

  # Helper method for castle_menu
  def valid_castling_sides
    row = @current_team == 'white' ? 0 : 7
    queen_sd = [0, row]
    king_sd = [7, row]

    valid_sds = ''

    valid_sds += 'q' if @logic.can_castle_from?(queen_sd, @current_team)
    valid_sds += 'k' if @logic.can_castle_from?(king_sd, @current_team)
    valid_sds = 'q/k' if valid_sds.length == 2

    valid_sds
  end

  # When a piece is formally moved, it's 'moved' status is also changed
  def formally_move(start_coord, end_coord)
    piece = @board[start_coord].piece
    @board.move_piece(start_coord, end_coord)
    # For special pieces like Pawns, where their possible moves depend on if the piece has moved or not
    piece.moved = true if piece.is_a?(Pawn) || piece.is_a?(King) || piece.is_a?(Rook)
  end

  # Returns a pawn that needs to be promoted
  def pawn_to_promote
    row = @current_team == 'white' ? 7 : 0 # The row we will check for the pawn promotion
    8.times do |i|
      piece = @board[[i, row]].piece
      return piece if !piece.nil? && piece.is_a?(Pawn) && piece.team == @current_team

    end
    nil # else nothing is returned, meaning there's nothing to promote
  end

  def save_game
    File.open(@file, "w") { |f| f.write "#{Date.today}\n#{dump_json}" }
  end
end
