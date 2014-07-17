require_relative 'board'

class Game

  attr_accessor :board

  def initialize
    @board = Board.new
    @turn = :d
  end

  def play
    i = 0

    until i == 10
      begin
        @board.display

        if @turn == :l
          puts "White's turn!"
        else
          puts "Black's turn!"
        end

        if @board.jump_available?(@turn)
          puts "You have a jump available!"
        end

        puts "Where is the piece that you'd like to move (two numbers, separated by a comma)?"
        start_pos = gets.chomp.split(",").map { |num| num.to_i }

        if @board[start_pos].moves.empty?
          raise CheckersError, "That piece can't move!"
        elsif @board.jump_available?(@turn) && @board[start_pos].simple_moves == @board[start_pos].moves
          raise CheckersError, "That piece can't jump!"
        end

        puts "Where will that piece end up?"
        end_pos = gets.chomp.split(",").map { |num| num.to_i }

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
      rescue ChessError => e
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

  def next_jump(start_pos)
    @board.display
    puts "Where should this piece jump next?"

    end_pos = gets.chomp.split(",").map { |num| num.to_i }

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



end


my_game = Game.new

#forced double jump scenario
#my_game.board[[0,1]] = nil
#francis = Piece.new(my_game.board, [3,4], :l)

#promotion scenario
francis = Piece.new(my_game.board, [0,1], :d)
my_game.board[[1,0]] = nil
my_game.board[[5,0]] = nil

my_game.play