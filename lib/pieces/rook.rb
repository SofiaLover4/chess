# frozen_string_literal: true

require_relative '../piece'
require_relative './generic_moves/cross_moves'
require 'json'

# Rook class for Chessboard
class Rook < Piece
  attr_accessor :symbol, :board, :moved

  include CrossMoves
  def initialize(team, board, coordinates)
    super(team, board, coordinates)
    @symbol = team == 'white' ? '♖'.black : '♜'.black
    @moved = false
  end

  def moved?
    @moved
  end

  def update_possible_moves
    # The moves are the same no matter the team
    @possible_moves = Set.new
    CrossMoves.instance_methods(false).each do |method|
      @possible_moves.merge(send(method, self))
    end
  end

  def dump_json
    {
      'team' => @team,
      'coordinates' => @coordinates,
      'moved' => @moved,
      'possible_moves' => @possible_moves.to_a
    }.to_json
  end

  def self.load_json(json_string, board)
    data = JSON.parse(json_string)
    new_rook = self.new(data['team'], board, data['coordinates'])
    new_rook.moved = data['moved']
    new_rook.possible_moves = Set.new(data['possible_moves'])

    new_rook
  end

  def ==(other)
    return false unless other.is_a?(Rook)

    @team == other.team && @coordinates == other.coordinates && @moved == other.moved && @possible_moves == other.possible_moves
  end

end
