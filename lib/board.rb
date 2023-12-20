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
