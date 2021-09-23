# frozen_string_literal: true

require_relative '../lib/game'

# rubocop: disable Metrics/BlockLength
describe Game do
  describe 'initialize' do
    # Initialize -> Creates other objects. Should test messages are sent
  end

  describe '#game_loop' do
    # Likely just a looping script calling other methods. Should test that
    # it behaves as expected]
    subject(:game) { described_class.new }
    let(:board) { game.instance_variable_get(:@board) }
    let(:player1) { game.instance_variable_get(:@player1) }
    let(:player2) { game.instance_variable_get(:@player2) }

    context 'when first player wins on first turn' do
      before do
        allow(game).to receive(:puts)
        allow(game).to receive(:finalize_player_action_loop)
        allow(board).to receive(:update_state)
        allow(board).to receive(:win?).and_return(true)
      end

      it 'runs #finalize_player_action_loop once' do
        expect(game).to receive(:finalize_player_action_loop).once
        game.game_loop
      end

      it 'asks board to update state once' do
        expect(board).to receive(:update_state).once
        game.game_loop
      end

      it 'asks board for win once' do
        expect(board).to receive(:win?).once
        game.game_loop
      end

      it 'displays player 1 win message once' do
        expect(game).to receive(:puts).with("#{player1.name}, you win.").once
        game.game_loop
      end

      it 'does not ask board for tie' do
        expect(board).not_to receive(:tie?)
        game.game_loop
      end

      it 'does not display game tie message' do
        expect(game).not_to receive(:puts).with('The game ends in a tie.')
        game.game_loop
      end
    end
  end

  describe '#solicit_player_action' do
    # Ask the player for their column, then send column and piece (depending
    # on player's symbol) to board
    subject(:game) { described_class.new }
    let(:board) { game.instance_variable_get(:@board) }

    before do
      allow(game).to receive(:puts)
    end

    context 'when player gives valid column' do
      it 'asks player for choice' do
        expect(game).to receive(:puts)
        game.solicit_player_action
      end

      it 'returns 1 when player sends "1"' do
        player_entry = '1'
        column = 1
        allow(game).to receive(:gets).and_return(player_entry)
        expect(game.solicit_player_action).to eq(column)
        game.solicit_player_action
      end

      it 'returns 11 when player sends "11"' do
        player_entry = '11'
        column = 11
        allow(game).to receive(:gets).and_return(player_entry)
        expect(game.solicit_player_action).to eq(column)
        game.solicit_player_action
      end
    end
  end

  describe '#finalize_player_action_loop' do
    # Loops until player action is validated, returning the column and displaying error messages as
    # needed
    subject(:game) { described_class.new }
    let(:board) { game.instance_variable_get(:@board) }

    context 'when player action is a valid column and the column is not full' do
      before do
        column = 1
        allow(game).to receive(:solicit_player_action).and_return(column)
        allow(board).to receive(:valid_column?).and_return(true)
        allow(board).to receive(:column_full?).and_return(false)
      end

      it 'calls #solicit_player_action once' do
        expect(game).to receive(:solicit_player_action).once
        game.finalize_player_action_loop
      end

      it 'asks board if column is valid once' do
        expect(board).to receive(:valid_column?).once
        game.finalize_player_action_loop
      end

      it 'asks board if column is full once' do
        expect(board).to receive(:column_full?).once
        game.finalize_player_action_loop
      end

      it 'does not display invalid column message' do
        expect(game).not_to receive(:puts).with('Invalid column.')
        game.finalize_player_action_loop
      end

      it 'does not display full column message' do
        expect(game).not_to receive(:puts).with('Column is full.')
        game.finalize_player_action_loop
      end

      it 'returns column' do
        expect(game.finalize_player_action_loop).to eq(1)
      end
    end

    context 'when player action is a invalid column once then valid column' do
      before do
        invalid_column = 11
        valid_column = 1
        allow(game).to receive(:solicit_player_action).and_return(invalid_column, valid_column)
        allow(game).to receive(:puts)
        allow(board).to receive(:valid_column?).and_return(false, true)
        allow(board).to receive(:column_full?).and_return(false)
      end

      it 'calls #solicit_player_action twice' do
        expect(game).to receive(:solicit_player_action).twice
        game.finalize_player_action_loop
      end

      it 'asks board if column is valid twice' do
        expect(board).to receive(:valid_column?).twice
        game.finalize_player_action_loop
      end

      it 'asks board if column is full once' do
        expect(board).to receive(:column_full?).once
        game.finalize_player_action_loop
      end

      it 'displays invalid column message once' do
        expect(game).to receive(:puts).with('Invalid column.').once
        game.finalize_player_action_loop
      end

      it 'does not display full column message' do
        expect(game).not_to receive(:puts).with('Column is full.')
        game.finalize_player_action_loop
      end

      it 'returns column' do
        expect(game.finalize_player_action_loop).to eq(1)
      end
    end

    context 'when player action is a full column, then valid and not full column' do
      before do
        full_column = 1
        valid_column = 5
        allow(game).to receive(:solicit_player_action).and_return(full_column, valid_column)
        allow(game).to receive(:puts)
        allow(board).to receive(:valid_column?).and_return(true, true)
        allow(board).to receive(:column_full?).and_return(true, false)
      end

      it 'calls #solicit_player_action twice' do
        expect(game).to receive(:solicit_player_action).twice
        game.finalize_player_action_loop
      end

      it 'asks board if column is valid twice' do
        expect(board).to receive(:valid_column?).twice
        game.finalize_player_action_loop
      end

      it 'asks board if column is full twice' do
        expect(board).to receive(:column_full?).twice
        game.finalize_player_action_loop
      end

      it 'does not display invalid column message' do
        expect(game).not_to receive(:puts).with('Invalid column.')
        game.finalize_player_action_loop
      end

      it 'displays full column message once' do
        expect(game).to receive(:puts).with('Column is full.').once
        game.finalize_player_action_loop
      end

      it 'returns column' do
        expect(game.finalize_player_action_loop).to eq(5)
      end
    end
  end

  describe '#display_welcome_message' do
    # Does not need to be tested. Will only be a series of puts statements
  end

  describe '#display_win_message' do
    # No need to test. Just puts
  end

  describe '#display_tie_message' do
    # No need to test. Just puts
  end
end
# rubocop: enable Metrics/BlockLength
