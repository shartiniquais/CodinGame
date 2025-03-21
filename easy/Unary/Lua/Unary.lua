-- Auto-generated code below aims at helping you parse
-- the standard input according to the problem statement.

msg = io.read()
output = ""
bn = ""
b = '\0'

function toBinary(num)
    local binary = ""
    while num > 0 do
        binary = (num % 2) .. binary
        num = math.floor(num / 2)
    end
    return string.rep("0", 7 - #binary) .. binary -- Pad with leading zeros to make it 7 bits
end

for i = 1, #msg do
    c = msg:sub(i, i)
    -- convert to ascii
    ascii = string.byte(c)
    -- convert to binary
    binary_value = toBinary(ascii)
    -- append the binary value to the binary string
    bn = bn .. binary_value
end

for i = 1, #bn do
    c = bn:sub(i, i)
    if c ~= b then
        if c == '1' then
            output = output .. " 0 "
        else
            output = output .. " 00 "
        end
        b = c
    end
    output = output .. "0"
end

-- trim the output
output = output:sub(2, #output)

print(output)