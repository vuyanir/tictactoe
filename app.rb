class Board
	attr_accessor :board, :player1, :player2, :status, :turn
	
	def initialize(player1, player2)

		@player1 = player1
		@player2 = player2

		@board = [[0, 0, 0],\
							[0, 0, 0],\
							[0, 0, 0]]

		@status = true
    @turn = @player1
    
    start_game()

  end

	def display_board()
    @board.each{|row|
      row.each { |block|
        print "#{block}\t"
      }
      puts "\n\n"}
	end

	def play_selection(selection)
		update_board(selection)

		if check_board()
			puts "#{@turn.name} is the WINNER!!!"
			@status = false
		end

		switch_turn()
	end

  private

  def start_game()
    puts 'TIC * TAC * TOE'
    puts '======================'
    puts "\n"
  end

  def switch_turn()
		if @turn == player1
			@turn = player2
		else
			@turn = player1
		end
	end

	def validate_selection(row, column)

    if @board[row][column] != 0
      return false                
    end
    
		return true
	end

	def update_board(selection)		
		row = selection[0]
    column = selection[1]
    
    if row > 2 || column > 2
      raise "Invalid selection. Options available are 0-2 only. Please try again."
    end

		if validate_selection(row, column)
			@board[row][column] = @turn.indicator
		else
			raise "Position already selected. Try a different position"
		end
  end

  def check_x_result(i)
		result = @board[i].select{ |j| j == @turn.indicator }

		return result.length
	end

	def check_y_result(i)

		result = []

		3.times{ |y| result << @board[y][i] if @board[y][i] == @turn.indicator }

		return result.length
	end

  def check_d_result(i)

		result = []

		if i == 0
			3.times { |d|
				result << @board[d][d] if @board[d][d] == @turn.indicator}
		end

		if i == 2
			3.times { |d| 
				j = i - d
				result << d if @board[d][j] == @turn.indicator
			}
		end

		return result.length
	end

  def check_board()

		3.times { |i|

			if check_x_result(i) == 3 || check_y_result(i) == 3 || check_d_result(i) == 3
				return true
			end
		}

		return false
  end
end

class Player
	attr_accessor :selection
  attr_reader :indicator, :name
  
  @@indicators = []
	def initialize(name)
			@name = name
      @indicator = @name[0]
  end
end

player1 = Player.new('Vuyani')
player2 = Player.new('Yolanda')
game = Board.new(player1, player2)

while game.status

	game.display_board()

	begin
		selection = []

		print "#{game.turn.name} - Enter row position(0-2): "
		row = gets.chomp
		selection << row.to_i

		print "#{game.turn.name} - Enter column position(0-2): "
		cols = gets.chomp
		selection << cols.to_i

    game.play_selection(selection)
    
    puts "\n"

	rescue SignalException=>e
		puts ''
		exit

	rescue Exception=>e
		puts e
		retry

	end  
end