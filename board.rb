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

    unless self[end_pos].jumping_moves.empty?
      if self[end_pos].jumping_moves.length == 1
        move(end_pos, self[end_pos].jumping_moves.first)
      else
        next_jump = next_jump(end_pos)
        move(end_pos, next_jump)
      end
    end

  end

  def next_jump(start_pos)
    display
    puts "Where should this piece jump next?"

    end_pos = gets.chomp.split(",").map { |num| num.to_i }
    move(pos, end_pos)

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