class CheckersError < StandardError
end

class Piece

  attr_accessor :king, :deltas, :pos
  attr_reader :color

  def initialize(board, pos, color)
    @pos = pos
    @king = false
    @color = color
    @board = board
    @board[pos] = self

    if color == :d
      @deltas = [[-1, -1], [1,-1]]
    else
      @deltas = [[-1, 1], [1, 1]]
    end

  end

  def inspect
    if color == :d
      if king
        " ♚ "
      else
        " ⚈ "
      end
    else
      if king
        " ♔ "
      else
        " ⚆ "
      end
    end
  end

  # def to_s
 #    if color == :d
 #      " ⚈ "
 #    else
 #      " ⚆ "
 #    end
 #  end


  def moves
    simple_moves + jumping_moves
  end

  def simple_moves
    moves = []

    @deltas.each do |(dx, dy)|
      moves << [pos.first + dx, pos.last + dy]
    end

    moves.select { |move| on_board?(move) && not_blocked?(move) }
  end

  def jumping_moves
    moves = []

    @deltas.each do |(dx, dy)|
      if enemy?([pos.first + dx, pos.last + dy])

        unless @board[[pos.first + (2 * dx), pos.last + (2 *dy)]]
          moves << [pos.first + (2 * dx), pos.last + (2 *dy)]
        end
      end
    end

    moves.select { |move| on_board?(move) && not_blocked?(move) }
  end

  private

  def enemy?(pos)
    if @board[pos] and @board[pos].color != color
      return true
    end
    false
  end

  def not_blocked?(pos)
    @board[pos] == nil
  end

  def on_board?(move)
    move.all? { |pos| pos.between?(0, 7) }
  end

end

# class DarkPiece < Piece
#
#   def initialize(pos, board)
#     @color = :d
#
#     super(pos, board)
#   end
#
#
# end
#
#
# class LightPiece < Piece
#
#   def initialize(pos, board)
#     @color = :l
#
#     super(pos, board)
#   end
#
#
#
# end