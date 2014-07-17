require_relative 'board'

class Game

  def initialize
    @board = Board.new
    @turn = :d
  end

  def play

      @board.display

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

      @board.display

    #promotes pieces to king
    #toggles the turn


  end
end

my_game = Game.new
my_game.play