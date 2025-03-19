-- Auto-generated code below aims at helping you parse
-- the standard input according to the problem statement.

n = tonumber(io.read()) -- the number of temperatures to analyse

if n == 0 then
    print(0)
    return
end

-- variable values to store the temperatures
values = {}

next_token = string.gmatch(io.read(), "[^%s]+")
for i=0,n-1 do
    -- t: a temperature expressed as an integer ranging from -273 to 5526
    t = tonumber(next_token())
    -- store the temperature in the values table
    values[i] = t
end

min_value = values[0]
min_distance = math.abs(min_value)

for i=1,n-1 do
    distance = math.abs(values[i])
    if distance < min_distance or (distance == min_distance and values[i] > min_value) then
        min_value = values[i]
        min_distance = distance
    end
end

-- Write an answer using print()
-- To debug: io.stderr:write("Debug message\n")

print(min_value)