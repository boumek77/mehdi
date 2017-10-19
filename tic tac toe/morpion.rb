require_relative 'player'
require_relative 'board'
require_relative 'boardcase'

class Game
  attr_reader :game_turn, :player1, :player2, :grid, :game_state, :board_array, :error, :end
  def initialize
    @game_turn = 0
    @player1 = Player.new
    @player2 = Player.new
    @grid = Board.new
    @game_state = "playing"
    @board_array = []
    @error = false
    @end = false
  end

  def ask_name
    puts "\n\n  Welcome to ### TIC TAC TOE ### !\n\n"
    print "Player 1 name?: "
    @player1.name = gets.chomp
    print "Player 2 name?: "
    @player2.name = gets.chomp
  end

  def ask_move
    @error = false
    while @error == false && @end == false
      @game_turn += 1

      if @game_turn % 2 == 1
        print "#{@player1.name} write the coordinates to add a X: "
        @coord = gets.chomp.downcase
        self.fill_array(@player1)
        break if @error || @end
        self.fill_boardcase("X")
        puts grid.display_board
        self.check_victory(@player1, @player1.player_array)
        break if @end

      else
        print "#{@player2.name} write the coordinates to add a O: "
        @coord = gets.chomp.downcase
        self.fill_array(@player2)
        break if @error || @end
        self.fill_boardcase("O")
        puts grid.display_board
        self.check_victory(@player2, @player2.player_array)
        break if @end
      end
    end
  end

  def fill_array(player)
    coord_value = @grid.grid_hash[@coord.to_sym]
    if coord_value == nil
      @error = true
      puts "Wrong coordinates, please enter again"
      @game_turn -= 1
      self.ask_move
    elsif @board_array.include?(coord_value)
      @error = true
      puts "Coordinates already entered. Please enter again"
      @game_turn -= 1
      self.ask_move
    else
      @board_array << coord_value
      player.player_array << coord_value
    end
  end

  def fill_boardcase(sign)
    case @coord
    when "a1"
      @grid.a1_case.case_state = sign
    when "b1"
      @grid.b1_case.case_state = sign
    when "c1"
      @grid.c1_case.case_state = sign
    when "a2"
      @grid.a2_case.case_state = sign
    when "b2"
      @grid.b2_case.case_state = sign
    when "c2"
      @grid.c2_case.case_state = sign
    when "a3"
      @grid.a3_case.case_state = sign
    when "b3"
      @grid.b3_case.case_state = sign
    when "c3"
      @grid.c3_case.case_state = sign
    end
  end

  def check_victory (player, array)
    case array.length
    when 3
      self.victory(player) if array[0] + array[1] + array[2] == 15
    when 4
      if (array[0] + array[1] + array[3] == 15  ||
          array[0] + array[2] + array[3] == 15  ||
          array[1] + array[2] + array[3] == 15)
        self.victory(player)
      end
    when 5
      if (array[0] + array[1] + array[4] == 15 ||
          array[0] + array[4] + array[4] == 15 ||
          array[0] + array[3] + array[4] == 15 ||
          array[1] + array[2] + array[4] == 15 ||
          array[1] + array[3] + array[4] == 15 ||
          array[2] + array[3] + array[4] == 15)
        self.victory(player)
      else
        self.draw
      end
    end
  end

  def victory (player)
    @game_state = "victory"
    puts "#{player.name} you have won !!"
    @end = true
  end

  def draw
    @game_state = "draw"
    puts "It's a draw..."
    @end = true
  end

  def round
    self.ask_name
    loop do
      puts "List of players: #{@player1.name} vs #{@player2.name}"
      @grid.display_board
      self.ask_move
      answer = ""
      while (answer != "Y")
        print "Play again? (Y/n): "
        answer = gets.chomp
        answer = answer
        break if answer == "n"
      end
      break if answer == "n"
      @player1.player_array = []
      @player2.player_array = []
      player2_name = @player1.name
      @player1.name = @player2.name
      @player2.name = player2_name
      @board_array = []
      @grid = Board.new
      @game_state = "playing"
      @game_turn = 0
      @end = false
    end
  end
end

one = Game.new
one.round