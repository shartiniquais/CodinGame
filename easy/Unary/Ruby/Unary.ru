# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

msg = gets.chomp

output = ""
bn = ""
b = ''

msg.each_char do |c|
    # convert to ascii
    ascii = c.ord
    # convert to binary
    binaryValue = ascii.to_s(2)
    # add leading zeros
    binary = binaryValue.rjust(7, '0')
    # add binary to bn
    bn += binary
end

bn.each_char do |c|
    if c!=b
        output += c == '0' ? " 00 " : " 0 "
        b = c
    end
    output += "0"
end

puts output.strip

