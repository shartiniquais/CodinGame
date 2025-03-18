STDOUT.sync = true # DO NOT REMOVE
# CodinGame planet is being attacked by slimy insectoid aliens.
# <---
# Hint: To protect the planet, you can implement the pseudo-code provided in the statement, below the player.

# game loop
loop do
  enemy_1 = gets.chomp # name of enemy 1
  dist_1 = gets.to_i # distance to enemy 1
  enemy_2 = gets.chomp # name of enemy 2
  dist_2 = gets.to_i # distance to enemy 2

  # Write an action using puts
  # To debug: STDERR.puts "Debug messages..."

  # Determine which enemy is closer and print its name
  puts dist_1 < dist_2 ? enemy_1 : enemy_2
end