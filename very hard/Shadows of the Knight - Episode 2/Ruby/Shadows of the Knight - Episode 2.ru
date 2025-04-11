STDOUT.sync = true # DO NOT REMOVE

#########################################################################################################
# Function narrow_dimension:                                                                           #
# Updates the search interval in one dimension                                                         #
# based on the feedback and the comparison between the previous and current position.                  #
#                                                                                                       #
# Parameters:                                                                                           #
#   prev: previous position on axis (x0 or y0)                                                          #
#   current: current position on axis (x or y)                                                          #
#   min_: current lower bound (x_min or y_min)                                                          #
#   max_: current upper bound (x_max or y_max)                                                          #
#   info: feedback string ("WARMER", "COLDER", "SAME", "UNKNOWN")                                       #
#########################################################################################################
def narrow_dimension(prev, current, min_, max_, info)
  sum = prev + current

  if info == "SAME"
    if sum.even?
      middle = sum / 2
      min_ = middle
      max_ = middle
    end
  elsif info == "WARMER"
    if current > prev
      new_lower = (sum / 2) + 1
      min_ = new_lower if new_lower > min_
    elsif current < prev
      new_upper = sum.even? ? (sum / 2) - 1 : sum / 2
      max_ = new_upper if new_upper < max_
    end
  elsif info == "COLDER"
    if current > prev
      new_upper = sum.even? ? (sum / 2) - 1 : sum / 2
      max_ = new_upper if new_upper < max_
    elsif current < prev
      new_lower = (sum / 2) + 1
      min_ = new_lower if new_lower > min_
    end
  end

  [min_, max_]
end

#########################################################################################################
# Function narrow:                                                                                      #
# Applies narrow_dimension on x if x is not yet determined; otherwise applies it to y.                  #
#########################################################################################################
def narrow(x0, y0, x, y, x_min, x_max, y_min, y_max, info)
  STDERR.puts "narrow: x0: #{x0} y0: #{y0} x_min: #{x_min} x_max: #{x_max} y_min: #{y_min} y_max: #{y_max} info: #{info}"

  if x_min != x_max
    x_min, x_max = narrow_dimension(x0, x, x_min, x_max, info)
  elsif y_min != y_max
    y_min, y_max = narrow_dimension(y0, y, y_min, y_max, info)
  end

  STDERR.puts "narrow : x_min: #{x_min} x_max: #{x_max} y_min: #{y_min} y_max: #{y_max}"
  [x_min, x_max, y_min, y_max]
end

# Input
w, h = gets.split.map(&:to_i)
_ = gets.to_i
x0, y0 = gets.split.map(&:to_i)

x = x0
y = y0

x_min = 0
x_max = w - 1
y_min = 0
y_max = h - 1

# Main loop
loop do
  info = gets.chomp

  x_min, x_max, y_min, y_max = narrow(x0, y0, x, y, x_min, x_max, y_min, y_max, info)

  STDERR.puts "narrow results: x_min: #{x_min} x_max: #{x_max} y_min: #{y_min} y_max: #{y_max}"

  x0 = x
  y0 = y

  if x_min != x_max
    if x0 == 0 && (x_max + x_min + 1 != w)
      x = (3 * x_min + x_max) / 2 - x0
    elsif x0 == w - 1 && (x_max + x_min + 1 != w)
      x = (x_min + 3 * x_max) / 2 - x0
    else
      x = x_max + x_min - x0
    end

    x += 1 if x == x0
    x = 0 if x < 0
    x = w - 1 if x > w - 1
  else
    if x != x_min
      x = x_min
      x0 = x
      puts "#{x} #{y}"
      info = gets.chomp
    end

    if y_min != y_max
      if y0 == 0 && (y_max + y_min + 1 != h)
        y = (3 * y_min + y_max) / 2 - y0
      elsif y0 == h - 1 && (y_max + y_min + 1 != h)
        y = (y_min + 3 * y_max) / 2 - y0
      else
        y = y_max + y_min - y0
      end

      y += 1 if y == y0
      y = 0 if y < 0
      y = h - 1 if y > h - 1
    else
      y = y_min
    end
  end

  puts "#{x} #{y}"
end
