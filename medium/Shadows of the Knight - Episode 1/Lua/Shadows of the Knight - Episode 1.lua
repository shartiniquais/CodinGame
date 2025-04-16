-- Auto-generated code below aims at helping you parse
-- the standard input according to the problem statement.

-- W: width of the building.
-- H: height of the building.
next_token = string.gmatch(io.read(), "[^%s]+")
w = tonumber(next_token())
h = tonumber(next_token())
_ = tonumber(io.read()) -- maximum number of turns before game over. (not used)
next_token = string.gmatch(io.read(), "[^%s]+")
x0 = tonumber(next_token())
y0 = tonumber(next_token())

left = 0
right = w - 1
top = 0
bottom = h - 1

-- game loop
while true do
    bombDir = io.read() -- the direction of the bombs from batman's current location (U, UR, R, DR, D, DL, L or UL)
    
    if string.find(bombDir, "U") then
        bottom = y0 - 1
    elseif string.find(bombDir, "D") then
        top = y0 + 1
    end
    if string.find(bombDir, "L") then
        right = x0 - 1
    elseif string.find(bombDir, "R") then
        left = x0 + 1
    end
    
    x0 = math.floor((left + right) / 2)
    y0 = math.floor((top + bottom) / 2)

    -- the location of the next window Batman should jump to.
    print(x0 .. " " .. y0)
end