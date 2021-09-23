# frozen_string_literal: true

class Board
  def initialize
    @state = [[nil, nil, nil, nil, nil, nil, nil], [nil, nil, nil, nil, nil, nil, nil], [nil, nil, nil, nil, nil, nil, nil], [nil, nil, nil, nil, nil, nil, nil], [nil, nil, nil, nil, nil, nil, nil], [nil, nil, nil, nil, nil, nil, nil]]
  end

  def update_state(piece, column)
    # loop through each row until empty cell in that column is found,
    # then place piece there and stop loop
    @state.each do |row|
      if row[column].nil?
        row[column] = piece
        break
      end
    end
  end

  # def display_board
  #   puts " _ _ _ _ _ _ _
  #   |#{@state[5][0]}|#{@state[5][1]}|#{@state[5][2]}|#{@state[5][3]}|#{@state[5][4]}|#{@state[5][5]}|#{@state[5][6]}|
  #   |#{@state[4][0]}|#{@state[4][1]}|#{@state[4][2]}|#{@state[4][3]}|#{@state[4][4]}|#{@state[4][5]}|#{@state[4][6]}|
  #   |#{@state[3][0]}|#{@state[3][1]}|#{@state[3][2]}|#{@state[3][3]}|#{@state[3][4]}|#{@state[3][5]}|#{@state[3][6]}|
  #   |#{@state[2][0]}|#{@state[2][1]}|#{@state[2][2]}|#{@state[2][3]}|#{@state[2][4]}|#{@state[2][5]}|#{@state[2][6]}|
  #   |#{@state[1][0]}|#{@state[1][1]}|#{@state[1][2]}|#{@state[1][3]}|#{@state[1][4]}|#{@state[1][5]}|#{@state[1][6]}|
  #   |#{@state[0][0]}|#{@state[0][1]}|#{@state[0][2]}|#{@state[0][3]}|#{@state[0][4]}|#{@state[0][5]}|#{@state[0][6]}|
  #    _ _ _ _ _ _ _"
  # end

  def display_blank_board
    puts "     _ _ _ _ _ _ _
    |_|_|_|_|_|_|_|
    |_|_|_|_|_|_|_|
    |_|_|_|_|_|_|_|
    |_|_|_|_|_|_|_|
    |_|_|_|_|_|_|_|
    |_|_|_|_|_|_|_|
     0 1 2 3 4 5 6"
  end

  def column_full?(column)
    result = true
    @state.each do |row|
      if row[column].nil?
        result = false
        break
      end
    end
    result
  end

  def valid_column?(column)
    column >= 0 && column < 7
  end

  def win?
    row_win? || column_win? || diagonal_right_win? || diagonal_left_win?
  end

  def row_win?
    result = false
    @state.each do |row|
      next if row.all? { |cell| cell.nil? }

      row.each_with_index do |cell, i|
        # only check for win if the cell isn't empty, and the next 3 cells going
        # to the right aren't nil
        if !(cell.nil?) && !(row[i + 1].nil?) && !(row[i + 2].nil?) && !(row[i + 3].nil?)
          symbol = cell.symbol
          # declare win if the pieces in the next 3 cells going right have the
          # same symbol
          if row[i + 1].symbol == symbol && row[i + 2].symbol == symbol && row[i + 3].symbol == symbol
            result = true
            break
          end
        end
      end
      break if result == true
    end
    result
  end

  def column_win?
    result = false
    @state.each_with_index do |row, i|
      next if row.all? { |cell| cell.nil? }

      row.each_with_index do |cell, j|
        # only check for win if the cell isn't empty, and the next 3 rows going
        # up exist, and the next 3 cells going up aren't nil
        if !(cell.nil?) && !(@state[i + 1].nil?) && !(@state[i + 2].nil?) && !(@state[i + 3].nil?) && !(@state[i + 1][j].nil?) && !(@state[i + 2][j].nil?) && !(@state[i + 3][j].nil?)
          symbol = cell.symbol
          # declare win if the pieces in the next 3 cells going up have the
          # same symbol
          if @state[i + 1][j].symbol == symbol && @state[i + 2][j].symbol == symbol && @state[i + 3][j].symbol == symbol
            result = true
            break
          end
        end
      end
      break if result == true
    end
    result
  end

  # diagonal going up and right
  def diagonal_right_win?
    result = false

    @state.each_with_index do |row, i|
      next if row.all? { |cell| cell.nil? }

      row.each_with_index do |cell, j|
        # only check for win if the cell isn't empty, and the next 3 rows going
        # up exist, and the next 3 cells going up and right aren't nil
        if !(cell.nil?) && !(@state[i + 1].nil?) && !(@state[i + 2].nil?) && !(@state[i + 3].nil?) && !(@state[i + 1][j + 1].nil?) && !(@state[i + 2][j + 2].nil?) && !(@state[i + 3][j + 3].nil?)
          symbol = cell.symbol
          # declare win if the pieces in the next 3 cells going up and right
          # have the same symbol
          if @state[i + 1][j + 1].symbol == symbol && @state[i + 2][j + 2].symbol == symbol && @state[i + 3][j + 3].symbol == symbol
            result = true
            break
          end
        end
      end
      break if result == true
    end
    result
  end

  # diagonal going up and left
  def diagonal_left_win?
    result = false

    @state.each_with_index do |row, i|
      next if row.all? { |cell| cell.nil? }

      row.each_with_index do |cell, j|
        # only check for win if the cell isn't empty, and the next 3 rows going
        # up exist, and the next 3 cells going up and left aren't nil
        if !(cell.nil?) && !(@state[i + 1].nil?) && !(@state[i + 2].nil?) && !(@state[i + 3].nil?) && !(@state[i + 1][j - 1].nil?) && !(@state[i + 2][j - 2].nil?) && !(@state[i + 3][j - 3].nil?)
          symbol = cell.symbol
          # declare win if the pieces in the next 3 cells going up and left
          # have the same symbol
          if @state[i + 1][j - 1].symbol == symbol && @state[i + 2][j - 2].symbol == symbol && @state[i + 3][j - 3].symbol == symbol
            result = true
            break
          end
        end
      end
      break if result == true
    end
    result
  end

  def tie?
    @state.flatten.none? nil
  end
end
