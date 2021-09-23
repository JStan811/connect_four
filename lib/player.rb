# frozen_string_literal: true

class Player
  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end

  attr_reader :name, :symbol
end
