# frozen_string_literal: true

require 'colorize'

# Nodes where peices will be stored within the game
class Square
  attr_accessor :peice, :coordinates, :distance, :previous, :content

  def initialize(format, coordinates)
    # The board will be read using [x,y] internally
    @format = format # Format is supposed to be a function
    @coordinates = coordinates
    @peice = nil

    @content = format.call(" #{@coordinates} ")
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

        board[i].push(Square.new(format, [i, j]))
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

  def show_board
    @board.each do |column|
      column.each do |square|
        print square.content
      end
      print "\n"
    end
  end
end
