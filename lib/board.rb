# frozen_string_literal: true

require 'colorize'

# Nodes where peices will be stored within the game
class Square
  attr_accessor :peice, :coordinates, :distance, :previous, :content

  def initialize(format, coordinates)
    @format = format # Format is supposed to be a function
    @coordinates = coordinates
    @peice = nil

    @content = format.call('   ')
  end
end

# A class for the board the user will see
class ChessBoard
  # ChessBoard is going to be the graph
  attr_accessor :board

  def create_board # rubocop:disable Metrics/MethodLength
    # Creating the board with colored squares
    board = Array.new(8) { [] }

    i = 7
    while i > -1
      j = 7
      while j > -1
        format = if (i + j).odd? # Color of the squares
                   ->(content) { content.on_black }
                 else
                   ->(content) { content.on_white }
                 end

        board[i].push(Square.new(format, [7 - j, 7 - i])) # The board will be read using traditional x, y notation internally
        j -= 1
      end
      i -= 1
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
