require_relative 'board'

class Game

  COL = {
    "a" => 0,
    "b" => 1,
    "c" => 2,
    "d" => 3,
    "e" => 4,
    "f" => 5,
    "g" => 6,
    "h" => 7
  }

  attr_accessor :board

  def initialize
    @board = Board.new
    @turn = :d
  end

  def play

    until over?(@turn)
      begin
        @board.display

        if @turn == :l
          puts "White's turn!"
        else
          puts "Red's turn!"
        end

        if @board.jump_available?(@turn)
          puts "You have a jump available!"
        end

        puts "Where is the piece that you'd like to move?"

        start_pos = translate(gets.chomp.split(""))

        if @board[start_pos].nil?
          raise CheckersError, "There's no piece there!"
        elsif @board[start_pos].color != @turn
          raise CheckersError, "That piece isn't yours!"
        elsif @board[start_pos].moves.empty?
          raise CheckersError, "That piece can't move!"
        elsif @board.jump_available?(@turn) && @board[start_pos].simple_moves == @board[start_pos].moves
          raise CheckersError, "That piece can't jump!"
        end

        puts "Where will that piece end up?"
        end_pos = translate(gets.chomp.split(""))

        if @board.jump_available?(@turn) && !@board[start_pos].jumping_moves.include?(end_pos)
          raise CheckersError, "That's not a jump!"
        end

        @board.move(start_pos, end_pos)

        unless @board[end_pos].jumping_moves.empty?
          if @board[end_pos].jumping_moves.length == 1
            @board.move(end_pos, @board[end_pos].jumping_moves.first)
          elsif @board[end_pos].jumping_moves.length > 1
            next_jump(end_pos)
          end
        end
      rescue CheckersError => e
        print e
        retry
      end

      promote

      if @turn == :d
        @turn = :l
      else
        @turn = :d
      end

      i += 1
    end
  end

  private

  def over?(color)
    @board.grid.each do |row|
      row.each do |piece|
        if piece && piece.color = color
          unless piece.moves.empty?
            return false
          end
        end
      end
    end
    true
  end


  def next_jump(start_pos)
    @board.display
    puts "Where should this piece jump next?"

    end_pos = translate(gets.chomp.split(""))

    if @board[start_pos].jumping_moves.include?(end_pos)
      @board.move(start_pos, end_pos)
    else
      raise CheckersError, "That's not a jumping move!"
    end

  end

  def promote
    @board.grid.each do |row|
      row.each do |piece|
        if piece && piece.pos.last == 0 and piece.color == :d
          piece.king = true
          piece.deltas = [[-1, 1], [-1, -1], [1, 1], [1, -1]]
        elsif piece && piece.pos.last == 7 and piece.color == :l
          piece.king = true
          piece.deltas = [[-1, 1], [-1, -1], [1, 1], [1, -1]]
        end
      end
    end
  end

  def translate(pos)
    pos[0] = COL[pos.first.downcase]
    pos[1] = 8 - pos.last.to_i
    pos
  end



end


my_game = Game.new

#forced double jump scenario
#my_game.board[[0,1]] = nil
#francis = Piece.new(my_game.board, [3,4], :l)

#promotion scenario
# francis = Piece.new(my_game.board, [0,1], :d)
# my_game.board[[1,0]] = nil
# my_game.board[[5,0]] = nil

my_game.play