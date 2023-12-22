# frozen_string_literal: true

require_relative '../lib/board'

describe ChessBoard do
  describe '#[]' do
    subject(:inputs) { described_class.new }

    context 'When giving invalid inputs' do
      it 'raises a TypeError' do
        expect { inputs['4', '2'] }.to raise_error(TypeError)
      end

      it 'raises an IndexError' do
        expect { inputs[4, 9] }.to raise_error(IndexError)
      end
    end

    context 'When giving valid inputs' do
      it 'returns the correct square' do
        8.times do |i|
          8.times { |j| expect(inputs[i, j].coordinates).to eq([i, j]) }
        end
      end
    end
  end
end
