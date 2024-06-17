# frozen_string_literal: true

require_relative '../lib/game_play'

# NOTE: Majority of the methods in this class here will be play tested to make sure the the board is functional

describe GamePlay do
  describe '#valid_user_coord' do
    it 'returns true for valid coordinates' do
      100.times do
        letter = rand(97..104).chr
        num = rand(49..56).chr
        coord = letter + num
        expect(GamePlay.new.valid_user_coord?(coord)).to be true
      end
    end

    it 'returns false for invalid coordinates' do
      coords = ['a0', '123', 'j3', 'aa', '11']
      coords.each { |invalid_input| expect(GamePlay.new.valid_user_coord?(invalid_input)).to be false }
    end
  end

  describe '#make_move_menu' do
    before do
      @board = ChessBoard.new(play: true)
      @game_play = GamePlay.new(board: @board)
      allow(@game_play).to receive(:display_game)
      allow(@game_play).to receive(:puts)
      allow(@game_play).to receive(:print)
    end
    it 'ends the game when user inputs "back"' do
      allow(@game_play).to receive(:gets).and_return('back')
      expect(@game_play.make_move_menu([1, 1])).to eq(nil)
    end

    it 'returns after several invalid inputs and then a valid input and moves the piece' do
      allow(@game_play).to receive(:gets).and_return('naw', 'a1', 'b3')
      expect(@game_play.make_move_menu([1, 1])).to eq(nil)
      expect(@board[[1, 2]].piece.is_a?(Pawn)).to be true
      expect(@board[[1, 1]].piece).to eq(nil)
    end

    it 'finishes after an en passant capture' do
      board = ChessBoard.new
      board.add_piece([5, 4], King, 'white')
      board.add_piece([7, 4], King, 'black')
      board.add_piece([0, 0], Pawn, 'white')
      board.add_piece([1, 2], Pawn, 'black')
      board.update_all_pieces
      w_pawn = board[[0, 0]].piece
      b_pawn = board[[1, 2]].piece

      game_play = GamePlay.new(board: board)
      allow(game_play).to receive(:display_game)
      allow(game_play).to receive(:puts)
      allow(game_play).to receive(:print)

      allow(game_play).to receive(:gets).and_return('a3') # Leaves pawn open for an en passant
      # Simulating the game
      game_play.make_move_menu([0, 0])

      allow(game_play).to receive(:gets).and_return('a2')
      game_play.make_move_menu([1, 2])

      expect(board.white_out).to include(w_pawn) # The pawn was captured
      expect(board[[0, 1]].piece).to equal(b_pawn) # The piece was moved properly
    end

  end

  describe '#play_menu' do
    before(:each) do
      @board = ChessBoard.new
      @game_play = GamePlay.new(board: @board)
      allow(@game_play).to receive(:display_game)
      allow(@game_play).to receive(:puts)
      allow(@game_play).to receive(:print)
      allow_any_instance_of(GamePlay).to receive(:save_menu)
    end

    it 'ends the game when black puts white into a check mate' do
      @board.add_piece([0, 1], King, 'white')
      @board.add_piece([7, 7], King, 'black')
      @board.add_piece([1, 7], Rook, 'black')
      @board.add_piece([1, 6], Rook, 'black')
      @board.update_all_pieces
      @game_play.current_team = 'black'
      allow(@game_play).to receive(:gets).and_return('m', 'b8', 'a8') # Making the moves that go into check_mate
      @game_play.play_menu
      expect(@game_play.game_over).to be true
      expect(@game_play.message).to eq('CHECK MATE. Congratulations to black, they have won the game!!!')
    end

    it 'ends the game when white forces a stale mate on black' do
      @board.add_piece([0, 7], King, 'white')
      @board.add_piece([4, 1], Queen, 'white')
      @board.add_piece([7, 0], King, 'black')
      @board.update_all_pieces

      allow(@game_play).to receive(:gets).and_return('m', 'e2', 'f2') # Making the moves that go into stale_mate
      @game_play.play_menu

      expect(@game_play.game_over).to be true
      expect(@game_play.message).to eq('It seems like black has been stalemated! This game is a draw!')
    end

    it 'ends the game when a special draw happens' do
      @board.add_piece([0, 0], King, 'white')
      @board.add_piece([7, 7], King, 'black')
      @board.add_piece([7, 6], Pawn, 'white')
      @board.update_all_pieces

      allow(@game_play).to receive(:gets).and_return('m', 'h8', 'h7') # Making the moves that go into a draw
      @game_play.current_team = 'black'
      @game_play.play_menu
      expect(@game_play.game_over).to be true
      expect(@game_play.message).to eq('Game Over! This game has resulted in a draw!')
    end

  end
end
