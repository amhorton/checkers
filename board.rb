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

  def move(start_pos, end_pos)
    if self[start_pos].moves.include?(end_pos)
      self[end_pos] = self[start_pos]
      self[end_pos].pos = end_pos
      self[start_pos] = nil
    else
      raise CheckersError, "That piece can't move there!"
    end
  end

  def jump_available?(color)
    @grid.each do |row|
      row.each do |piece|
        if piece && piece.color == color and piece.simple_moves != piece.moves
          return true
        end
      end
    end
    false
  end

  def display
    p grid
  end

  private

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
my_board.display
my_board.move([5,4], [6,7])
my_board.display