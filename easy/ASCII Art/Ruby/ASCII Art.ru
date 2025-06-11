l = gets.to_i
h = gets.to_i
t = gets.chomp.upcase

ascii_art = []
h.times do
  ascii_art << gets.chomp
end

result = Array.new(h) { "" }

t.each_char do |c|
  index = c =~ /[A-Z]/ ? c.ord - 'A'.ord : 26


  h.times do |i|
    result[i] << ascii_art[i][index * l, l]
  end
end

result.each { |line| puts line }