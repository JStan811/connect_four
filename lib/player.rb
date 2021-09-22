# frozen_string_literal: true

class Player
  def place_piece(piece, position, board)
    board.update_state(piece, position)
  end
end
