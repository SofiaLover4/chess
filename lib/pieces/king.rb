# frozen_string_literal: true

require_relative '../piece'

# King piece for Chessboard
class King < Piece
  attr_accessor :symbol, :moved

  def initialize(team, board, coordinates)
    super(team, board, coordinates)
    @symbol = team == 'white' ? '♔'.black : '♚'.black
    @moved = false
  end

  def moved?
    @moved
  end

  def update_possible_moves
    # This method should be similar to the knights #update_possible_moves
    x = coordinates[0]
    y = coordinates[1]
    jumping_squares = [[x, y + 1], [x, y - 1], [x - 1, y], [x + 1, y],
                       [x + 1,  y + 1], [x - 1, y + 1], [x + 1, y - 1], [x - 1, y - 1]]
    @possible_moves = Set.new
    jumping_squares.each do |coord|
      @possible_moves.add(coord) if !out_of_bounds?(coord) && (board[coord].piece.nil? || possible_capture?(coord))
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
    new_king = self.new(data['team'], board, data['coordinates'])
    new_king.moved = data['moved']
    new_king.possible_moves = Set.new(data['possible_moves'])

    new_king
  end

  def ==(other)
    return false unless other.is_a?(King)

    @team == other.team && @coordinates == other.coordinates && @moved == other.moved && @possible_moves == other.possible_moves
  end
end