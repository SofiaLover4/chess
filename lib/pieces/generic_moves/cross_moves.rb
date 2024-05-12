# frozen_string_literal: true

module CrossMoves
  def right_moves(source_piece)
    moves = Set.new
    x = source_piece.coordinates[0] + 1
    y = source_piece.coordinates[1]
    until source_piece.out_of_bounds?([x, y])
      unless source_piece.board[[x, y]].piece.nil?
        moves << [x, y] if source_piece.possible_capture?([x, y])

        break
      end
      moves << [x, y]
      x += 1
    end
    moves
  end

  def left_moves(source_piece)
    moves = Set.new
    x = source_piece.coordinates[0] - 1
    y = source_piece.coordinates[1]

    until out_of_bounds?([x, y])
      unless source_piece.board[[x, y]].piece.nil?
        moves << [x, y] if source_piece.possible_capture?([x, y])

        break
      end

      moves << [x, y]
      x -= 1
    end
    moves
  end

  def forward_moves(source_piece)
    moves = Set.new
    x =  source_piece.coordinates[0]
    y =  source_piece.coordinates[1] + 1

    until source_piece.out_of_bounds?([x, y])
      unless  source_piece.board[[x, y]].piece.nil?
        moves << [x, y] if source_piece.possible_capture?([x, y])

        break
      end

      moves << [x, y]
      y += 1
    end
    moves
  end


  def back_moves(source_piece)
    moves = Set.new
    x = source_piece.coordinates[0]
    y = source_piece.coordinates[1] - 1

    until source_piece.out_of_bounds?([x, y])
      unless source_piece.board[[x, y]].piece.nil?
        moves << [x, y] if source_piece.possible_capture?([x, y])
        break
      end

      moves << [x, y]
      y -= 1
    end
    moves
  end
end