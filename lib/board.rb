# frozen_string_literal: true

require 'colorize'
Dir["#{File.dirname(__FILE__)}/./pieces/*.rb"].each do |file|
  require file
end

# Nodes where pieces will be stored within the game
class Square
  attr_accessor :piece, :coordinates, :distance, :previous, :format

  def initialize(format, coordinates)
    # The board will be read using [x, y]
    @format = format # Format is supposed to be a function
    @coordinates = coordinates
    @piece = nil
  end

  def content
    format.call(@piece.nil? ? '   ' : " #{@piece.symbol} ")
  end

  def inspect
    "Square: #{@coordinates} \nPiece: #{@piece} \nViewable Content: #{content} "
  end
end

# A class for the board the user will see
class ChessBoard
  # ChessBoard is going to be the graph
  attr_accessor :board, :white_in_play, :black_in_play, :white_king, :black_king

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
    unless self[coordinates].piece.nil? # To stop debugging rabbit holes
      raise exception, 'piece is already in this square '
    end

    tmp = piece.new(team, self, coordinates)
    organize_piece(tmp)
    self[coordinates].piece = (tmp)
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
  end

  def [](coordinates)
    @board[7 - coordinates[1]][coordinates[0]]
  end

  # Update the moves of all the pieces in play
  def update_all_pieces
    @white_in_play.each { |piece| piece.update_possible_moves }
    @black_in_play.each { |piece| piece.update_possible_moves }
  end

  def set_board
    load_pawns
    load_non_royals
    load_royals
    update_all_pieces
  end

  private

  # Loading in both white and black pawns onto the board
  def load_pawns
    8.times do |i|
      add_piece([i, 1], Pawn, 'white')
      add_piece([i, 6], Pawn, 'black')
    end
  end

  # Loading in pieces that are not pawns, king, or queen
  def load_non_royals
    # start at each corner and as you go in change the piece you are adding
    non_royals = [Rook, Knight, Bishop]
    3.times do |i|
      add_piece([i, 7], non_royals[i], 'black')
      add_piece([7 - i, 7], non_royals[i], 'black')
      add_piece([i, 0], non_royals[i],'white')
      add_piece([7 - i, 0], non_royals[i], 'white')
    end
  end

  # Loading in both kings onto the board
  def load_royals
    add_piece([4, 0], King, 'white')
    add_piece([4, 7], King, 'black')
    add_piece([3, 0], Queen, 'white')
    add_piece([3, 7], Queen,'black')
  end

end
