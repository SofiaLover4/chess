# frozen_string_literal: true

require 'colorize'

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
  attr_accessor :board, :white_in_play, :black_in_play

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

  def initialize
    @white_in_play = Set.new
    @black_in_play = Set.new
    @white_out = Set.new
    @black_out = Set.new
    @white_king = nil
    @black_king = nil
    # Class starts with an empty board
    @board = create_board
  end

  def add_piece(coordinates, piece, team)
    tmp = piece.new(team, self, coordinates)
    @white_in_play.add(tmp) if team == 'white'
    @black_in_play.add(tmp) if team == 'black'
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
end
