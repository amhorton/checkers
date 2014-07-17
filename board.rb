require_relative 'piece'

class Board

  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    populate_board
  end

  def [](pos)
    self.grid[pos.last][pos.first]
  end

  def []=(pos, piece)
    self.grid[pos.last][pos.first] = piece
  end

  def populate_board
    @grid.each_with_index do |row, y|

      row.each_index do |x|

        if (y == 0 || y == 2) && x % 2 != 0
          Piece.new(self, [x,y], :l)
        elsif y == 1 && x % 2 == 0
          Piece.new(self, [x,y], :l)
        elsif (y == 5 || y == 7) && x % 2 == 0
          Piece.new(self, [x,y], :d)
        elsif y == 6 && x % 2 != 0
          Piece.new(self, [x,y], :d)
        end

      end
    end
  end


end

my_board = Board.new
francis = Piece.new(my_board, [5,4], :l)
p my_board.grid
p my_board[[6,5]].moves