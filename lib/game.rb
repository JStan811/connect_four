# frozen_string_literal: true

require_relative 'board'
require_relative 'player'
require_relative 'piece'

class Game
  def initialize
    @board = Board.new
    @player1 = Player.new('Player 1', 'X')
    @player2 = Player.new('Player 2', 'O')
  end

  def game_loop
    display_welcome_message
    loop do
      player_turn(@player1)
      break if game_over?(@player1)

      player_turn(@player2)
      break if game_over?(@player2)
    end
  end

  def player_turn(player)
    puts "#{player.name}, your up."
    player_column = finalize_player_action_loop
    @board.update_state(player_column, Piece.new(player.symbol))
  end

  def game_over?(player)
    game_over = false
    if @board.win?
      puts "#{player.name}, you win."
      game_over = true
    elsif @board.tie?
      puts 'The game ends in a tie.'
      game_over = true
    end
    game_over
  end

  def solicit_player_action
    puts 'What column would you like to place your piece into?'
    gets.chomp.to_i
  end

  def finalize_player_action_loop
    column = 0
    loop do
      column = solicit_player_action
      if !(@board.valid_column?(column))
        puts 'Invalid column.'
        next
      elsif @board.column_full?(column)
        puts 'Column is full.'
        next
      end
      break
    end
    column
  end

  private

  def display_welcome_message
    puts 'Welcome to Connect Four.'
    puts ''
    puts "#{@player1.name}, your symbol is #{@player1.symbol}."
    puts "#{@player2.name}, yours is #{@player2.symbol}."
    puts ''
    puts 'Good luck.'
    puts ''
  end
end
