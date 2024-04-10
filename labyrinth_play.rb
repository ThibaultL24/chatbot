class Maze
    def initialize(width, height)
      @width = width
      @height = height
      @maze = Array.new(height * 2 + 1) { Array.new(width * 2 + 1, "#") }
      create_maze(1, 1)
      add_entry_exit
      @player_x = 1
      @player_y = 1
      play_game
    end
  
    private
  
    def create_maze(x, y)
      directions = [[x, y - 2], [x, y + 2], [x - 2, y], [x + 2, y]].shuffle
  
      directions.each do |new_x, new_y|
        if new_y.between?(1, @height * 2) && new_x.between?(1, @width * 2) && @maze[new_y][new_x] == "#"
          @maze[y + (new_y - y) / 2][x + (new_x - x) / 2] = " "
          @maze[new_y][new_x] = " "
          create_maze(new_x, new_y)
        end
      end
    end
  
    def add_entry_exit
      @maze[1][0] = " "
      @maze[@height * 2 - 1][@width * 2] = " "
    end
  
    def display_maze
      @maze.each_with_index do |row, y|
        row.each_with_index do |cell, x|
          if x == @player_x && y == @player_y
            print "@"
          else
            print cell
          end
        end
        puts
      end
    end
  
    def play_game
      loop do
        system("clear") || system("cls") # Efface l'écran du terminal (Linux/OS X ou Windows)
        display_maze
  
        input = gets.chomp.downcase
        case input
        when "w"
          move_player(0, -1)
        when "s"
          move_player(0, 1)
        when "a"
          move_player(-1, 0)
        when "d"
          move_player(1, 0)
        when "exit"
          break
        end
  
        break if @player_x == @width * 2 && @player_y == @height * 2 - 1
      end
    end
  
    def move_player(dx, dy)
      new_x = @player_x + dx
      new_y = @player_y + dy
      if new_x.between?(0, @width * 2) && new_y.between?(0, @height * 2) && @maze[new_y][new_x] == " "
        @player_x = new_x
        @player_y = new_y
      end
    end
  end
  
  width = 10
  height = 10
  
  Maze.new(width, height)