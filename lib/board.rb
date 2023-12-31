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
  attr_accessor :board

  def create_board # rubocop:disable Metrics/MethodLength
    # Creating the board with colored squares
    board = Array.new(8) { [] }

    i = 0
    while i < 8
      j = 0
      while j < 8
        format = if (i + j).odd? # Color of the squares
                   ->(content) { content.on_black }
                 else
                   ->(content) { content.on_white }
                 end

        board[i].push(Square.new(format, [j, 7 - i]))
        j += 1
      end
      i += 1
    end
    board
  end

  def initialize
    # Class starts with an empty board
    @board = create_board
  end

  def add_piece(coordinates, piece, team)
    self[coordinates].piece = piece.new(team, self, coordinates)
  end

  def show_board
    @board.each do |column|
      column.each do |square|
        print square.content
      end
      print "\n"
    end
  end

  def [](coordinates)
    @board[7 - coordinates[1]][coordinates[0]]
  end
end
