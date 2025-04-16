STDOUT.sync = true # DO NOT REMOVE
# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

# w: width of the building.
# h: height of the building.
w, h = gets.split.map { |x| x.to_i }
_ = gets.to_i # maximum number of turns before game over. (not used)
x0, y0 = gets.split.map { |x| x.to_i }

left = 0
right = w - 1
top = 0
bottom = h - 1

# game loop
loop do
    bomb_dir = gets.chomp # the direction of the bombs from batman's current location (U, UR, R, DR, D, DL, L or UL)

    if bomb_dir.include?("U")
        bottom = y0 - 1
    elsif bomb_dir.include?("D")
        top = y0 + 1
    end
    if bomb_dir.include?("L")
        right = x0 - 1
    elsif bomb_dir.include?("R")
        left = x0 + 1
    end

    x0 = (left + right) / 2
    y0 = (top + bottom) / 2

    puts "#{x0} #{y0}"
end
