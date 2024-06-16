# frozen_string_literal: true

require 'json'

# A foundation for all the chess pieces
class Piece
  attr_accessor :team, :board, :coordinates
  attr_writer :possible_moves

  def initialize(team, board, coordinates)
    @team = team
    @board = board
    @coordinates = coordinates
    @possible_moves = Set.new
  end

  def out_of_bounds?(coordinates)
    x = coordinates[0]
    y = coordinates[1]

    x < 0 || x > 7 || y < 0 || y > 7
  end

  def possible_moves(&block)
    if block_given?
      @possible_moves.each { |move| block.call(move) } # Will be used to show possible moves on the board
    else
      @possible_moves
    end
  end

  def possible_capture?(coordinates)
    @board[coordinates].piece.team != @team
  end

  def inspect
    "#{@team} #{self.class} on #{@coordinates}:\nPossible Moves: #{@possible_moves}"
  end

  def dump_json
    {
      'team' => @team,
      'coordinates' => @coordinates,
      'possible_moves' => @possible_moves.to_a
    }.to_json
  end

  def self.load_json(json_string, board)
    data = JSON.parse(json_string)

    new_piece = self.new(data['team'], board, data['coordinates'])
    new_piece.possible_moves = Set.new(data['possible_moves'])

    new_piece
  end
end
