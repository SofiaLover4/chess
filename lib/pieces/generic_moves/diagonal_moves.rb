# frozen_string_literal: true

module DiagonalMoves
  def right_diag_up(source_piece)
    moves = Set.new
    x = source_piece.coordinates[0] + 1
    y = source_piece.coordinates[1] + 1
    until source_piece.out_of_bounds?([x, y]) do
      unless source_piece.board[[x,y]].piece.nil?
        moves << [x, y] if source_piece.possible_capture?([x, y])
        break
      end
      moves << [x, y]
      x += 1
      y += 1
    end
    moves
  end

  def left_diag_up(source_piece)
    moves = Set.new
    x = source_piece.coordinates[0] - 1
    y = source_piece.coordinates[1] + 1
    until source_piece.out_of_bounds?([x, y]) do
      unless source_piece.board[[x,y]].piece.nil?
        moves << [x, y] if source_piece.possible_capture?([x, y])
        break
      end
      moves << [x, y]
      x -= 1
      y += 1
    end
    moves
  end

  def right_diag_down(source_piece)
    moves = Set.new
    x = source_piece.coordinates[0] + 1
    y = source_piece.coordinates[1] - 1
    until source_piece.out_of_bounds?([x, y]) do
      unless source_piece.board[[x, y]].piece.nil?
        moves << [x, y] if source_piece.possible_capture?([x, y])
        break
      end
      moves << [x, y]
      x += 1
      y -= 1
    end
    moves
  end

  def left_diag_down(source_piece)
    moves = Set.new
    x = source_piece.coordinates[0] - 1
    y = source_piece.coordinates[1] - 1
    until source_piece.out_of_bounds?([x, y]) do
      unless source_piece.board[[x, y]].piece.nil?
        moves << [x, y] if source_piece.possible_capture?([x, y])
        break
      end
      moves << [x, y]
      x -= 1
      y -= 1
    end
    moves
  end
end
