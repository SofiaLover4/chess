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

    i = 0
    while i < 8
      j = 0
      while j < 8
        square = (i + j).even? ? '   '.on_white : '   '.on_black
        board[i].push(square)
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
      column.each do |tile|
        print tile
      end
      print "\n"
    end
  end
end
