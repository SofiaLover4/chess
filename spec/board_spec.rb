# frozen_string_literal: true

require_relative '../lib/board'

describe ChessBoard do
  describe '#[]' do
    subject(:inputs) { described_class.new }
    # Invalid inputs won't be tested here because the program has full control of how
    # this method is used.
    context 'When giving valid inputs' do
      it 'returns the correct square' do
        8.times do |i|
          8.times { |j| expect(inputs[[i, j]].coordinates).to eq([i, j]) }
        end
      end
    end
  end
end
