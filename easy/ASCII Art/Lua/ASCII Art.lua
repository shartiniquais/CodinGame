L = tonumber(io.read())
H = tonumber(io.read())
T = io.read():upper()

asciiArt = {}
for i = 1, H do
    asciiArt[i] = io.read()
end

result = {}
for i = 1, H do
    result[i] = ""
end

for i = 1, #T do
    local c = T:sub(i, i)
    local index
    if c:match("%a") and c >= 'A' and c <= 'Z' then
        index = string.byte(c) - string.byte('A')
    else
        index = 26
    end

    for j = 1, H do
        local startIdx = index * L + 1
        local endIdx = startIdx + L - 1
        result[j] = result[j] .. asciiArt[j]:sub(startIdx, endIdx)
    end
end

print(table.concat(result, "\n"))
