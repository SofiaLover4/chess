# frozen_string_literal: true

require_relative 'board'
require_relative 'chess_logic'

# Where the actual chessGame will be played and the menus
class GamePlay

  def initialize(board: ChessBoard.new(play: true))
    @board = board
    @logic = ChessLogic.new(board: board) # Yeah this is some wierd annoying variable naming
    @current_team = 'white'
    @message = nil # For methods that want to give the user a message
  end

  def switch_team
    @current_team = @current_team == 'white' ? 'black' : 'white'
  end

  def display_game
    @board.show_board
    puts @message unless @message.nil?
  end
  def play_menu
    # Idea is to have several different commands that a user can input after they have started the game
    # In a sense this is the 'main' screen the user will be interacting with
    # The idea is to have the options as ...
    # 1. end - this option ends the game and ideally lets the user choose with they want to save the current game that t
    #   are playing
    # 2. castle - this will be the castling routine where the user has to select a valid rook and other stuff like that
    # 3. If its neither of these two the game will check if what you wrote follows the format for selecting a piece
    #     (aka its typed correctly, the square that was chosen has to have a piece and the piece must be on your team )
    #     Note: You could do this all in one condition but maybe for different steps you return different messages
    #    and if it does then you go into the player_move routine where you have your selected piece
    # 4. if neither of these work just run back up to the top of the loop
    # Something else important to keep track of is that teams should switch
    loop do
      @board.show_board
      print "So, #{@current_team} what will you do?: "
      user_input = gets.chomp.downcase
      if user_input == 'end'
        break
      elsif user_input == 'm'
        select_piece_menu
      end
    end
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

        # For when a pawn is moved in such a way that it is left open for an en passant
        open_to_en_passant = @logic.open_to_en_passant?(piece, move_coord)

        # This is handling an en passant. In short terms, you move the pawn to the enemy pawn to capture it and then move
        # the pawn back to it's original square. After, you do the proper move after the if statement
        if piece.is_a?(Pawn) && move_coord == piece.en_passant_attk
          @board.move_piece(piece_square, [piece.en_passant_attk[0], piece_square[1]])
          @board.move_piece([piece.en_passant_attk[0], piece_square[1]], piece_square)
        end

        @board.move_piece(piece_square, move_coord)


        # For special pieces like Pawns, where their possible moves depend on if the piece has moved or not
        piece.moved = true if piece.is_a?(Pawn) || piece.is_a?(King) || piece.is_a?(Rook)

        @message = nil
        switch_team # Player has made a valid move, so it's no longer their turn
        @board.update_moves_for(@current_team) # Now that the team has switch update the new player's movee

        piece.add_en_passant_move if piece.is_a?(Pawn) && open_to_en_passant # For a future en passant attack
        break
      else
        @message = 'Sorry, but that is not a valid move'
      end
    end

  end
end
