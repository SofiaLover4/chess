# frozen_string_literal: true

require 'colorize'
Dir["#{File.dirname(__FILE__)}/./pieces/*.rb"].each do |file|
  require file
end
Dir["#{File.dirname(__FILE__)}/./board_modules/*.rb"].each do |file|
  require file
end

# Nodes where pieces will be stored within the game
class Square
  attr_accessor :piece, :coordinates, :distance, :previous, :format

  def initialize(format, coordinates)
    # The board will be read using [x, y]
    @default_format = format # Format is supposed to be a function
    @current_format = @default_format
    @coordinates = coordinates
    @piece = nil
  end

  def content
    @current_format.call(@piece.nil? ? '   ' : " #{@piece.symbol} ")
  end

  def piece?
    !@piece.nil?
  end

  # Purpose is to highlight the selected moves of a piece
  def highlight_possible_move
    @current_format = if !piece?
                        if (coordinates[0] + coordinates[1]).odd?
                          ->(content) { content.on_light_green }
                        else
                          ->(content) { content.on_green }
                        end
                      else # There is a piece
                        ->(content) { content.on_light_red }
                      end
  end

  # Purpose is for highlighting the square square the user selected
  def highlight_selected
    @current_format = ->(content) { content.on_light_cyan }
  end

  # Will be used for resetting any highlighting
  def clear
    @current_format = @default_format
  end

  def inspect
    "Square: #{@coordinates} \nPiece: #{@piece} \nViewable Content: #{content} "
  end
end

# A class for the board the user will see
class ChessBoard
  # ChessBoard is going to be the graph
  attr_accessor :board, :white_in_play, :black_in_play, :white_king, :black_king, :white_out, :black_out

  include SetUp

  def create_board # rubocop:disable Metrics/MethodLength
    # Creating the board with colored squares
    board = Array.new(8) { [] }

    i = 0
    while i < 8
      j = 0
      while j < 8
        format = if (i + j).even? # Color of the squares
                   ->(content) { content.on_light_yellow }
                 else
                   ->(content) { content.on_yellow }
                 end

        board[i].push(Square.new(format, [j, 7 - i]))
        j += 1
      end
      i += 1
    end
    board
  end

  def initialize(play: false)
    @white_in_play = Set.new
    @black_in_play = Set.new
    @white_out = Set.new
    @black_out = Set.new
    @white_king = nil
    @black_king = nil
    # Board will empty unless play is True
    @board = create_board
    set_board if play
  end

  def organize_piece(piece)
    # Extra step for adding a King
    if piece.team == 'white'
      @white_king = piece if piece.is_a?(King)
      @white_in_play.add(piece)
    else
      @black_king = piece if piece.is_a?(King)
      @black_in_play.add(piece)
    end
  end

  def add_piece(coordinates, piece, team)
    raise 'piece is already in this square' unless self[coordinates].piece.nil? # To stop debugging rabbit holes

    tmp = piece.new(team, self, coordinates)
    organize_piece(tmp)
    self[coordinates].piece = (tmp)
  end

  def out_of_bounds?(coordinates)
    x = coordinates[0]
    y = coordinates[1]

    x < 0 || x > 7 || y < 0 || y > 7
  end

  # You move the piece at the start_coord to the location at the end_coord
  # If there is a piece there it must be an enemy piece and it will be 'captured'
  # Method does NOT take into account if the move is a valid_move, that will be for the game to decide
  def move_piece(start_coord, end_coord)
    raise StandardError, 'trying to access coordinates out of bounds' if out_of_bounds?(start_coord) || out_of_bounds?(end_coord)

    raise StandardError, 'no piece in this square' if self[start_coord].piece.nil?

    piece = self[start_coord].piece
    unless self[end_coord].piece.nil?
      raise StandardError, 'friendly piece trying to be captured' if self[end_coord].piece.team == piece.team

      take_out(self[end_coord].piece)
    end
    self[start_coord].piece = nil
    self[end_coord].piece = piece
    piece.coordinates = end_coord

  end

  def show_board
    @board.each_with_index do |column, i |
      print " #{8 - i} "
      column.each do |square|
        print square.content
      end
      print "\n"
    end
    puts '    a  b  c  d  e  f  g  h'
    puts "White has captured: #{out_set_to_s(@black_out)}"
    puts "Black has captured: #{out_set_to_s(@white_out)}"

  end

  def [](coordinates)
    @board[7 - coordinates[1]][coordinates[0]]
  end

  # Update the moves of all the pieces in play
  def update_all_pieces
    @white_in_play.each { |piece| piece.update_possible_moves }
    @black_in_play.each { |piece| piece.update_possible_moves }
  end

  def clear_all_highlighting
    @board.each { |column| column.each {|square| square.clear } }
  end


  private

  # Method goes hand in hand with #move_piece
  def take_out(piece)
    if piece.team == 'white'
      @white_in_play.delete(piece)
      @white_out.add(piece)
    else # The team is black
      @black_in_play.delete(piece)
      @black_out.add(piece)
    end
  end

  # For displaying the pieces that have been captured. Pieces are displayed in order of
  # decreasing rank
  def out_set_to_s(out_set)
    piece_dict = { Queen => 1, Rook => 2, Bishop => 3, Knight => 4, Pawn => 5 }
    pieces = out_set.to_a
    sorted_pieces = pieces.sort_by { |piece| piece_dict[piece.class] }
    pieces_string = ''
    sorted_pieces.each { |piece| pieces_string += " #{piece.symbol} "}

    pieces_string
  end

end
