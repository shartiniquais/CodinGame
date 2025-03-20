STDOUT.sync = true # DO NOT REMOVE
# The while loop represents the game.
# Each iteration represents a turn of the game
# where you are given inputs (the heights of the mountains)
# and where you have to print an output (the index of the mountain to fire on)
# The inputs you are given are automatically updated according to your last actions.


# game loop
loop do
  biggest = 0
  num = 0

  for i in 0..7
    mountain_h = gets.to_i # represents the height of one mountain.

    if biggest < mountain_h
      biggest = mountain_h
      num = i
    end
  end

  # Write an action using puts
  # To debug: STDERR.puts "Debug messages..."

  puts num # The index of the mountain to fire on.
end
