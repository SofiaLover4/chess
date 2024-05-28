# frozen_string_literal: true

# Setting up the board as if a brand new Chess game is starting.
module SetUp
  # Loading in the pawns
  def load_pawns
    8.times do |i|
      add_piece([i, 1], Pawn, 'white')
      add_piece([i, 6], Pawn, 'black')
    end
  end

  # Loading in pieces that are not pawns, king, or queen
  def load_non_royals
    # start at each corner and as you go in change the piece you are adding
    non_royals = [Rook, Knight, Bishop]
    3.times do |i|
      add_piece([i, 7], non_royals[i], 'black')
      add_piece([7 - i, 7], non_royals[i], 'black')
      add_piece([i, 0], non_royals[i],'white')
      add_piece([7 - i, 0], non_royals[i], 'white')
    end

  end

  # Loading in both kings onto the board
  def load_royals
    add_piece([4, 0], King, 'white')
    add_piece([4, 7], King, 'black')
    add_piece([3, 0], Queen, 'white')
    add_piece([3, 7], Queen,'black')
  end

  def set_board
    load_pawns
    load_non_royals
    load_royals
    update_all_pieces
  end
end
