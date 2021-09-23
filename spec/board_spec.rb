# frozen_string_literal: true

require_relative '../lib/board'

# rubocop: disable Metrics/BlockLength
describe Board do
  describe '#update_state' do
    subject(:board) { described_class.new }
    let(:piece_to_place) { instance_double('piece') }

    context 'when selected column is empty' do
      it 'puts piece into selected column, first row' do
        column = 3
        state = board.instance_variable_get(:@state)
        expect { board.update_state(piece_to_place, column) }.to change { state[0][column] }.to(piece_to_place)
      end
    end

    context 'when selected column has one piece in it' do
      it 'puts piece into selected column, second row' do
        column = 3
        state = board.instance_variable_get(:@state)
        preexisting_piece = instance_double('piece')
        state[0][3] = preexisting_piece
        expect { board.update_state(piece_to_place, column) }.to change { state[1][column] }.to(piece_to_place)
      end
    end
  end

  describe '#column_full?' do
    subject(:board) { described_class.new }

    context 'when column has no empty slots' do
      it 'is full' do
        column = 3
        state = board.instance_variable_get(:@state)
        state[0][3] = instance_double('piece')
        state[1][3] = instance_double('piece')
        state[2][3] = instance_double('piece')
        state[3][3] = instance_double('piece')
        state[4][3] = instance_double('piece')
        state[5][3] = instance_double('piece')
        expect(board.column_full?(3)).to be true
      end
    end

    context 'when column has all empty slots' do
      it 'is not full' do
        column = 3
        expect(board.column_full?(column)).to be false
      end
    end

    context 'when column has one empty slot in the top row' do
      it 'is not full' do
        column = 3
        state = board.instance_variable_get(:@state)
        state[0][3] = instance_double('piece')
        state[1][3] = instance_double('piece')
        state[2][3] = instance_double('piece')
        state[3][3] = instance_double('piece')
        state[4][3] = instance_double('piece')
        expect(board.column_full?(column)).to be false
      end
    end
  end

  describe '#valid_column?' do
    subject(:board) { described_class.new }

    context 'when column is not 0-6' do
      it 'is not valid column' do
        column = 7
        expect(board.valid_column?(column)).to be false
      end
    end

    context 'when column is 0-6' do
      it 'is valid column' do
        column = 6
        expect(board.valid_column?(column)).to be true
      end
    end
  end

  describe '#row_win?' do
    subject(:board) { described_class.new }
    let(:piece1) { instance_double('piece') }
    let(:piece2) { instance_double('piece') }
    let(:piece3) { instance_double('piece') }
    let(:piece4) { instance_double('piece') }

    context 'when there are 4 pieces with the same symbol in the first 4 cells in a row' do
      before do
        allow(piece1).to receive(:symbol).and_return('X')
        allow(piece2).to receive(:symbol).and_return('X')
        allow(piece3).to receive(:symbol).and_return('X')
        allow(piece4).to receive(:symbol).and_return('X')
      end

      it 'is a player win' do
        state = board.instance_variable_get(:@state)
        state[0][0] = piece1
        state[0][1] = piece2
        state[0][2] = piece3
        state[0][3] = piece4
        expect(board.row_win?).to be true
      end
    end

    context 'when there are 4 pieces with the same symbol in the last 4 cells in a row' do
      before do
        allow(piece1).to receive(:symbol).and_return('X')
        allow(piece2).to receive(:symbol).and_return('X')
        allow(piece3).to receive(:symbol).and_return('X')
        allow(piece4).to receive(:symbol).and_return('X')
      end

      it 'is a player win' do
        state = board.instance_variable_get(:@state)
        state[0][3] = piece1
        state[0][4] = piece2
        state[0][5] = piece3
        state[0][6] = piece4
        expect(board.row_win?).to be true
      end
    end

    context 'when there are 4 pieces with the same symbol in the last 4 cells in a different row' do
      before do
        allow(piece1).to receive(:symbol).and_return('X')
        allow(piece2).to receive(:symbol).and_return('X')
        allow(piece3).to receive(:symbol).and_return('X')
        allow(piece4).to receive(:symbol).and_return('X')
      end

      it 'is a player win' do
        state = board.instance_variable_get(:@state)
        state[3][3] = piece1
        state[3][4] = piece2
        state[3][5] = piece3
        state[3][6] = piece4
        expect(board.row_win?).to be true
      end
    end

    context 'when there are 4 pieces in a row but not with the same symbol' do
      before do
        allow(piece1).to receive(:symbol).and_return('X')
        allow(piece2).to receive(:symbol).and_return('X')
        allow(piece3).to receive(:symbol).and_return('O')
        allow(piece4).to receive(:symbol).and_return('O')
      end

      it 'is not a player win' do
        state = board.instance_variable_get(:@state)
        state[0][0] = piece1
        state[0][1] = piece2
        state[0][2] = piece3
        state[0][3] = piece4
        expect(board.row_win?).to be false
      end
    end

    context 'when there are only 3 pieces in a row with the same symbol' do
      before do
        allow(piece1).to receive(:symbol).and_return('X')
        allow(piece2).to receive(:symbol).and_return('X')
        allow(piece3).to receive(:symbol).and_return('X')
      end

      it 'is not a player win' do
        state = board.instance_variable_get(:@state)
        state[0][1] = piece1
        state[0][2] = piece2
        state[0][3] = piece3
        expect(board.row_win?).to be false
      end
    end

    context 'when the 3 pieces are the last three cells in the row' do
      before do
        allow(piece1).to receive(:symbol).and_return('X')
        allow(piece2).to receive(:symbol).and_return('X')
        allow(piece3).to receive(:symbol).and_return('X')
      end

      it 'is not a player win' do
        state = board.instance_variable_get(:@state)
        state[0][4] = piece1
        state[0][5] = piece2
        state[0][6] = piece3
        expect(board.row_win?).to be false
      end
    end

    context 'when the board is empty' do
      it 'is not a player win' do
        expect(board.row_win?).to be false
      end
    end
  end

  describe '#column_win?' do
    subject(:board) { described_class.new }
    let(:piece1) { instance_double('piece') }
    let(:piece2) { instance_double('piece') }
    let(:piece3) { instance_double('piece') }
    let(:piece4) { instance_double('piece') }

    context 'when there are 4 pieces with the same symbol in the first 4 cells in a column' do
      before do
        allow(piece1).to receive(:symbol).and_return('X')
        allow(piece2).to receive(:symbol).and_return('X')
        allow(piece3).to receive(:symbol).and_return('X')
        allow(piece4).to receive(:symbol).and_return('X')
      end

      it 'is a player win' do
        state = board.instance_variable_get(:@state)
        state[0][0] = piece1
        state[1][0] = piece2
        state[2][0] = piece3
        state[3][0] = piece4
        expect(board.column_win?).to be true
      end
    end

    context 'when there are 4 pieces with the same symbol in the last 4 cells in a column' do
      before do
        allow(piece1).to receive(:symbol).and_return('X')
        allow(piece2).to receive(:symbol).and_return('X')
        allow(piece3).to receive(:symbol).and_return('X')
        allow(piece4).to receive(:symbol).and_return('X')
      end

      it 'is a player win' do
        state = board.instance_variable_get(:@state)
        state[2][0] = piece1
        state[3][0] = piece2
        state[4][0] = piece3
        state[5][0] = piece4
        expect(board.column_win?).to be true
      end
    end

    context 'when there are 4 pieces with the same symbol in the last 4 cells in a different column' do
      before do
        allow(piece1).to receive(:symbol).and_return('X')
        allow(piece2).to receive(:symbol).and_return('X')
        allow(piece3).to receive(:symbol).and_return('X')
        allow(piece4).to receive(:symbol).and_return('X')
      end

      it 'is a player win' do
        state = board.instance_variable_get(:@state)
        state[2][3] = piece1
        state[3][3] = piece2
        state[4][3] = piece3
        state[5][3] = piece4
        expect(board.column_win?).to be true
      end
    end

    context 'when there are 4 pieces in a column but not with the same symbol' do
      before do
        allow(piece1).to receive(:symbol).and_return('X')
        allow(piece2).to receive(:symbol).and_return('X')
        allow(piece3).to receive(:symbol).and_return('O')
        allow(piece4).to receive(:symbol).and_return('O')
      end

      it 'is not a player win' do
        state = board.instance_variable_get(:@state)
        state[0][0] = piece1
        state[1][0] = piece2
        state[2][0] = piece3
        state[3][0] = piece4
        expect(board.column_win?).to be false
      end
    end

    context 'when there are only 3 pieces in a column with the same symbol' do
      before do
        allow(piece1).to receive(:symbol).and_return('X')
        allow(piece2).to receive(:symbol).and_return('X')
        allow(piece3).to receive(:symbol).and_return('X')
      end

      it 'is not a player win' do
        state = board.instance_variable_get(:@state)
        state[0][0] = piece1
        state[1][0] = piece2
        state[2][0] = piece3
        expect(board.column_win?).to be false
      end
    end

    context 'when the 3 pieces are the last three cells in the column' do
      before do
        allow(piece1).to receive(:symbol).and_return('X')
        allow(piece2).to receive(:symbol).and_return('X')
        allow(piece3).to receive(:symbol).and_return('X')
      end

      it 'is not a player win' do
        state = board.instance_variable_get(:@state)
        state[3][3] = piece1
        state[4][3] = piece2
        state[5][3] = piece3
        expect(board.column_win?).to be false
      end
    end

    context 'when the board is empty' do
      it 'is not a player win' do
        expect(board.column_win?).to be false
      end
    end
  end

  describe '#diagonal_right_win?' do
    subject(:board) { described_class.new }
    let(:piece1) { instance_double('piece') }
    let(:piece2) { instance_double('piece') }
    let(:piece3) { instance_double('piece') }
    let(:piece4) { instance_double('piece') }

    context 'when there are 4 pieces with the same symbol in right diagonal starting from the first cell in the first row' do
      before do
        allow(piece1).to receive(:symbol).and_return('X')
        allow(piece2).to receive(:symbol).and_return('X')
        allow(piece3).to receive(:symbol).and_return('X')
        allow(piece4).to receive(:symbol).and_return('X')
      end

      it 'is a player win' do
        state = board.instance_variable_get(:@state)
        state[0][0] = piece1
        state[1][1] = piece2
        state[2][2] = piece3
        state[3][3] = piece4
        expect(board.diagonal_right_win?).to be true
      end
    end

    context 'when there are 4 pieces with the same symbol in a right diagonal from a cell in the middle of the board' do
      before do
        allow(piece1).to receive(:symbol).and_return('X')
        allow(piece2).to receive(:symbol).and_return('X')
        allow(piece3).to receive(:symbol).and_return('X')
        allow(piece4).to receive(:symbol).and_return('X')
      end

      it 'is a player win' do
        state = board.instance_variable_get(:@state)
        state[2][2] = piece1
        state[3][3] = piece2
        state[4][4] = piece3
        state[5][5] = piece4
        expect(board.diagonal_right_win?).to be true
      end
    end

    context 'when there are 4 pieces in a right diagonal but not with the same symbol' do
      before do
        allow(piece1).to receive(:symbol).and_return('X')
        allow(piece2).to receive(:symbol).and_return('X')
        allow(piece3).to receive(:symbol).and_return('O')
        allow(piece4).to receive(:symbol).and_return('O')
      end

      it 'is not a player win' do
        state = board.instance_variable_get(:@state)
        state[0][0] = piece1
        state[1][1] = piece2
        state[2][2] = piece3
        state[3][3] = piece4
        expect(board.diagonal_right_win?).to be false
      end
    end

    context 'when there are only 3 pieces in a right diagonal with the same symbol' do
      before do
        allow(piece1).to receive(:symbol).and_return('X')
        allow(piece2).to receive(:symbol).and_return('X')
        allow(piece3).to receive(:symbol).and_return('X')
      end

      it 'is not a player win' do
        state = board.instance_variable_get(:@state)
        state[0][0] = piece1
        state[1][1] = piece2
        state[2][2] = piece3
        expect(board.diagonal_right_win?).to be false
      end
    end

    context 'when the 3 pieces are the last three cells in a diagonal' do
      before do
        allow(piece1).to receive(:symbol).and_return('X')
        allow(piece2).to receive(:symbol).and_return('X')
        allow(piece3).to receive(:symbol).and_return('X')
      end

      it 'is not a player win' do
        state = board.instance_variable_get(:@state)
        state[3][4] = piece1
        state[4][5] = piece2
        state[5][6] = piece3
        expect(board.diagonal_right_win?).to be false
      end
    end

    context 'when the board is empty' do
      it 'is not a player win' do
        expect(board.diagonal_right_win?).to be false
      end
    end
  end

  describe '#diagonal_left_win?' do
    subject(:board) { described_class.new }
    let(:piece1) { instance_double('piece') }
    let(:piece2) { instance_double('piece') }
    let(:piece3) { instance_double('piece') }
    let(:piece4) { instance_double('piece') }

    context 'when there are 4 pieces with the same symbol in left diagonal starting from last cell in the last row' do
      before do
        allow(piece1).to receive(:symbol).and_return('X')
        allow(piece2).to receive(:symbol).and_return('X')
        allow(piece3).to receive(:symbol).and_return('X')
        allow(piece4).to receive(:symbol).and_return('X')
      end

      it 'is a player win' do
        state = board.instance_variable_get(:@state)
        state[0][6] = piece1
        state[1][5] = piece2
        state[2][4] = piece3
        state[3][3] = piece4
        expect(board.diagonal_left_win?).to be true
      end
    end

    context 'when there are 4 pieces with the same symbol in a left diagonal from a cell in the middle of the board' do
      before do
        allow(piece1).to receive(:symbol).and_return('X')
        allow(piece2).to receive(:symbol).and_return('X')
        allow(piece3).to receive(:symbol).and_return('X')
        allow(piece4).to receive(:symbol).and_return('X')
      end

      it 'is a player win' do
        state = board.instance_variable_get(:@state)
        state[2][4] = piece1
        state[3][3] = piece2
        state[4][2] = piece3
        state[5][1] = piece4
        expect(board.diagonal_left_win?).to be true
      end
    end

    context 'when there are 4 pieces in a left diagonal but not with the same symbol' do
      before do
        allow(piece1).to receive(:symbol).and_return('X')
        allow(piece2).to receive(:symbol).and_return('X')
        allow(piece3).to receive(:symbol).and_return('O')
        allow(piece4).to receive(:symbol).and_return('O')
      end

      it 'is not a player win' do
        state = board.instance_variable_get(:@state)
        state[0][6] = piece1
        state[1][5] = piece2
        state[2][4] = piece3
        state[3][3] = piece4
        expect(board.diagonal_left_win?).to be false
      end
    end

    context 'when there are only 3 pieces in a diagonal with the same symbol' do
      before do
        allow(piece1).to receive(:symbol).and_return('X')
        allow(piece2).to receive(:symbol).and_return('X')
        allow(piece3).to receive(:symbol).and_return('X')
      end

      it 'is not a player win' do
        state = board.instance_variable_get(:@state)
        state[0][6] = piece1
        state[1][5] = piece2
        state[2][4] = piece3
        expect(board.diagonal_left_win?).to be false
      end
    end

    context 'when the 3 pieces are the last three cells in a diagonal' do
      before do
        allow(piece1).to receive(:symbol).and_return('X')
        allow(piece2).to receive(:symbol).and_return('X')
        allow(piece3).to receive(:symbol).and_return('X')
      end

      it 'is not a player win' do
        state = board.instance_variable_get(:@state)
        state[3][2] = piece1
        state[4][1] = piece2
        state[5][0] = piece3
        expect(board.diagonal_left_win?).to be false
      end
    end

    context 'when the board is empty' do
      it 'is not a player win' do
        expect(board.diagonal_left_win?).to be false
      end
    end
  end

  describe '#win?' do
    subject(:board) { described_class.new }

    context 'when there is a row win' do
      it 'is a win' do
        allow(board).to receive(:row_win?).and_return(true)
        expect(board).to be_win
      end
    end

    context 'when there is a column win' do
      it 'is a win' do
        allow(board).to receive(:column_win?).and_return(true)
        expect(board).to be_win
      end
    end

    context 'when there is a right diagonal win' do
      it 'is a win' do
        allow(board).to receive(:diagonal_right_win?).and_return(true)
        expect(board).to be_win
      end
    end

    context 'when there is a left diagonal win' do
      it 'is a win' do
        allow(board).to receive(:diagonal_left_win?).and_return(true)
        expect(board).to be_win
      end
    end

    context 'when there is no win condition' do
      it 'is not a win' do
        allow(board).to receive(:row_win?).and_return(false)
        allow(board).to receive(:column_win?).and_return(false)
        allow(board).to receive(:diagonal_right_win?).and_return(false)
        allow(board).to receive(:diagonal_left_win?).and_return(false)
        expect(board).not_to be_win
      end
    end
  end

  describe '#tie?' do
    # this will always be run after the win check, so we don't need to check
    # for win
    subject(:board) { described_class.new }

    context 'when board is full' do
      it 'is a tie' do
        state = board.instance_variable_get(:@state)
        allow(state).to receive(:any?).and_return(false)
        expect(board).to be_tie
      end
    end

    context 'when board is not full' do
      it 'is not a tie' do
        state = board.instance_variable_get(:@state)
        allow(state).to receive(:any?).and_return(true)
        expect(board).not_to be_tie
      end
    end
  end
end
# rubocop: enable Metrics/BlockLength
