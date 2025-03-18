-- CodinGame planet is being attacked by slimy insectoid aliens.
-- <---
-- Hint: To protect the planet, you can implement the pseudo-code provided in the statement, below the player.

-- game loop
while true do
    local enemy1 = io.read() -- name of enemy 1
    local dist1 = tonumber(io.read()) -- distance to enemy 1
    local enemy2 = io.read() -- name of enemy 2
    local dist2 = tonumber(io.read()) -- distance to enemy 2
    
    -- Write an action using print()
    -- To debug: io.stderr:write("Debug message\n")
    
    -- Determine which enemy is closer and print its name
    print(dist1 < dist2 and enemy1 or enemy2)
end