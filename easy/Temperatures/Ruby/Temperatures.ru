# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

n = gets.to_i # the number of temperatures to analyse

if n == 0
  puts "0"
  exit
end

inputs = gets.split

min = 5526
min_dist = 5526

for i in 0..(n-1)
  # t: a temperature expressed as an integer ranging from -273 to 5526
  t = inputs[i].to_i
    if t.abs < min_dist
      min = t
      min_dist = t.abs
    elsif t.abs == min_dist && t > 0
      min = t
    end
end

# Write an answer using puts
# To debug: STDERR.puts "Debug messages..."

puts min
