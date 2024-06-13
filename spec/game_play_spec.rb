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
end
