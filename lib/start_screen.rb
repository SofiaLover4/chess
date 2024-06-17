# frozen_string_literal: true
require_relative './game_play'

class StartScreen
  def initialize
    @saves = Dir.glob('./saves/*txt')
    loop do # loop will end when the user hits q in the beginning menu
      file_number = beginning_menu
      file_number = file_number.to_i - 1
      file = @saves[file_number]
      file_data = File.read(file).split

      game = if file_data[0] == 'None'
                GamePlay.new
             else
                GamePlay.load_json(file_data[1])
             end

      game.file = file
      game.play_menu
    end
  end

  def display_saves
    @saves.each { |file| display_file(file)  }
  end

  def display_file(file)
    file_data = File.read(file).split
    name = file.chomp('.txt')[8..]
    if file_data[0] == 'None'
      puts "#{name} - empty"
    else
      puts "#{name} - Last Saved On: #{file_data[0]}"
    end
  end

  # Returns the save file the user wants to user
  def beginning_menu
    loop do
      system('clear')
      puts start_message
      display_saves
      print "\nPlease enter the number of the save file you would like to use or enter 'q' to quit or 'r' to reset a save slot:"
      user_input = gets.chomp
      return user_input if user_input.length == 1  && user_input.ord >= 49 && user_input.ord <= 51

      exit if user_input == 'q'
      clear_file_menu if user_input == 'r'

    end
  end

  def clear_file_menu
    loop do
      system('clear')
      display_saves
      puts "\nPlease enter the number of the slot that you want to delete or enter 'back' if you want to select a file to play in: "
      user_input = gets.chomp

      if user_input.length == 1  && user_input.ord >= 49 && user_input.ord <= 51
        file_number = user_input.to_i - 1
        file = @saves[file_number]
        File.open(file, "w") { |f| f.write 'None' }
      end

      break if user_input == 'back'
    end
  end



  private
  def start_message
    "♟♙︎\e[1m\e[34mCHESS\e[0m♟︎♙
Welcome to Chess! This program follows the majority of the major chess rules except three fold repetition
fivefold repetition, and the 50 move rule. Besides that, en passant, castling, and pawn promotion are
in the game!

Once you start or load into game there various commands you can input into the terminal!
\e[1mSome important to commands to take note of:\e[0m
  -\e[1m forfeit\e[0m - Like in real chess, the game ends here the player that types in this command loses
  -\e[1m end\e[0m - Will end the game but ask the user if they would like to save before taken back to the start screen
  -\e[1m s\e[0m - This is to save the game to the file you are playing on
  -\e[1m c\e[0m - This is to go to the castling menu
  -\e[1m m\e[0m - This is for moving a piece

\e[1mIn the castling menu you have a few options as well if they are available:\e[0m
  -\e[1m q\e[0m - For castling queen side
  -\e[1m k\e[0m - For castling king side
  -\e[1m back\e[0m - For going back to the main menu

The menus for selecting pieces and moving them around should be pretty straight forward, just make sure to use
use algebraic notation! One last thing, there is a promotion menu for when you move a pawn into a promotion
square. This happens automatically!

Alright, that's enough yapping. Go play some chess!

"
  end

end
