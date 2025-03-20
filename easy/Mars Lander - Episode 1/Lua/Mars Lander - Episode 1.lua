-- Auto-generated code below aims at helping you parse
-- the standard input according to the problem statement.

surfaceN = tonumber(io.read()) -- the number of points used to draw the surface of Mars.
for i=0,surfaceN-1 do
    -- landX: X coordinate of a surface point. (0 to 6999)
    -- landY: Y coordinate of a surface point. By linking all the points together in a sequential fashion, you form the surface of Mars.
    next_token = string.gmatch(io.read(), "[^%s]+")
    landX = tonumber(next_token())
    landY = tonumber(next_token())
end

-- game loop
while true do
    -- hSpeed: the horizontal speed (in m/s), can be negative.
    -- vSpeed: the vertical speed (in m/s), can be negative.
    -- fuel: the quantity of remaining fuel in liters.
    -- rotate: the rotation angle in degrees (-90 to 90).
    -- power: the thrust power (0 to 4).
    next_token = string.gmatch(io.read(), "[^%s]+")
    X = tonumber(next_token())
    Y = tonumber(next_token())
    hSpeed = tonumber(next_token())
    vSpeed = tonumber(next_token())
    fuel = tonumber(next_token())
    rotate = tonumber(next_token())
    power = tonumber(next_token())
    
    -- Write an action using print()
    -- To debug: io.stderr:write("Debug message\n")
    

    -- 2 integers: rotate power. rotate is the desired rotation angle (should be 0 for level 1), power is the desired thrust power (0 to 4).
    if vSpeed <= -40 then
        print("0 4")
    else
        print("0 0")
    end
end