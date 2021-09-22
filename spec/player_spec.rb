# frozen_string_literal: true

require_relative '../lib/player'

describe Player do
  describe '#initialize' do
    # Initialize -> No test necessary when only creating instance variables.
  end

  describe '#place_piece' do
    subject(:player) { described_class.new }
    let(:board) { instance_double('board') }
    let(:piece) { instance_double('piece') }

    it 'sends message with piece and position to the board' do
      column = '1'
      expect(board).to receive(:update_state)
      player.place_piece(piece, column, board)
    end
  end
end
