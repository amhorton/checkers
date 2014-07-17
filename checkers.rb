require_relative 'board'

class Game

  def initialize
    @board = Board.new
    @turn = :d
  end

  def play

    until over?

    #displays the board
    #checks whether the player whose turn it is has a jump available
    #displays something if a jump is available
    #asks for the player's move
    #if a jump is available, checks if you just made a jump, errors out if you      didn't
    #checks the piece you just moved to see if it has any jumps available
    #if there is only one, it makes the jump for you
    #if there is more than one, it asks you which to do, then continues to try      to make jumps for you, etc
    #promotes pieces to king
    #toggles the turn

    end
  end




end