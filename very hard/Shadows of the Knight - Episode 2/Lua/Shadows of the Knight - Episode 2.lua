-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- // Function narrow_dimension:                                                                                      //
-- //   Updates the search interval in one dimension                                                                  //
-- //   based on the feedback and the comparison between                                                              //
-- //   the previous position (x0 or y0) and the current position (x or y).                                           //
-- //                                                                                                                 //
-- // Parameters:                                                                                                     //
-- //   $1 : previous position on the axis (x0 or y0)                                                                 //
-- //   $2 : current position on the axis (x or y)                                                                    //
-- //   $3 : current lower bound (x_min or y_min)                                                                     //
-- //   $4 : current upper bound (x_max or y_max)                                                                     //
-- //   $5 : feedback ("WARMER", "COLDER", "SAME", "UNKNOWN")                                                         //
-- //                                                                                                                 //
-- // For SAME, if (x0+x) (or y0+y) is even, the bomb is                                                              //
-- // exactly in the middle.                                                                                          //
-- //                                                                                                                 //
-- // For WARMER/COLDER, we deduce which side of the interval to keep:                                                //
-- //   - If x > x0 and WARMER, the bomb is to the right of the middle,                                               //
-- //     so new_min = ((x0+x)/2) + 1.                                                                                //
-- //   - If x > x0 and COLDER, the bomb is to the left, so new_max = (x0+x)/2 - (if even) or = (x0+x)/2 (if odd).    //
-- //                                                                                                                 //
-- // The same reasoning applies for y.                                                                               //
-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function narrow_dimension(prev, current, min_, max_, info)
    if info == "SAME" then
        local sum = prev + current
        if sum % 2 == 0 then
            local middle = sum // 2
            min_ = middle
            max_ = middle
        end
    elseif info == "WARMER" then
        if current > prev then
            local sum = prev + current
            local new_lower = (sum // 2) + 1
            if new_lower > min_ then
                min_ = new_lower
            end
        elseif current < prev then
            local sum = prev + current
            local new_upper = (sum % 2 == 0) and (sum // 2 - 1) or (sum // 2)
            if new_upper < max_ then
                max_ = new_upper
            end
        end
    elseif info == "COLDER" then
        if current > prev then
            local sum = prev + current
            local new_upper = (sum % 2 == 0) and (sum // 2 - 1) or (sum // 2)
            if new_upper < max_ then
                max_ = new_upper
            end
        elseif current < prev then
            local sum = prev + current
            local new_lower = (sum // 2) + 1
            if new_lower > min_ then
                min_ = new_lower
            end
        end
    end
    return min_, max_
end

-- ////////////////////////////////////////////////////////////////
-- // Function narrow:                                           //
-- // Applies narrow_dimension on x as long as                   //
-- // the horizontal interval is not reduced to a single value,  //
-- // then on y if x is already determined.                      //
-- ////////////////////////////////////////////////////////////////
function narrow(x0, y0, x, y, x_min, x_max, y_min, y_max, info)
    io.stderr:write(string.format("narrow: x0: %d y0: %d x_min: %d x_max: %d y_min: %d y_max: %d info: %s\n", x0, y0, x_min, x_max, y_min, y_max, info))
    if x_min ~= x_max then
        x_min, x_max = narrow_dimension(x0, x, x_min, x_max, info)
    elseif y_min ~= y_max then
        y_min, y_max = narrow_dimension(y0, y, y_min, y_max, info)
    end
    io.stderr:write(string.format("narrow : x_min: %d x_max: %d y_min: %d y_max: %d\n", x_min, x_max, y_min, y_max))
    return x_min, x_max, y_min, y_max
end

-- Initialization
local next_token = string.gmatch(io.read(), "[^%s]+")
local w = tonumber(next_token())
local h = tonumber(next_token())
local _ = tonumber(io.read()) -- max turns, unused
next_token = string.gmatch(io.read(), "[^%s]+")
local x0 = tonumber(next_token())
local y0 = tonumber(next_token())
local x = x0
local y = y0

local x_min = 0
local x_max = w - 1
local y_min = 0
local y_max = h - 1

-- Game loop
while true do
    local info = io.read()

    x_min, x_max, y_min, y_max = narrow(x0, y0, x, y, x_min, x_max, y_min, y_max, info)
    io.stderr:write(string.format("narrow results: x_min: %d x_max: %d y_min: %d y_max: %d\n", x_min, x_max, y_min, y_max))

    x0 = x
    y0 = y

    if x_min ~= x_max then
        if x0 == 0 and x_max + x_min + 1 ~= w then
            x = (3 * x_min + x_max) // 2 - x0
        elseif x0 == w - 1 and x_max + x_min + 1 ~= w then
            x = (x_min + 3 * x_max) // 2 - x0
        else
            x = x_max + x_min - x0
        end
        if x == x0 then x = x0 + 1 end
        if x < 0 then x = 0 end
        if x > (w - 1) then x = w - 1 end
    else
        if x ~= x_min then
            x = x_min
            x0 = x
            print(string.format("%d %d", x, y))
            info = io.read()
        end

        if y_min ~= y_max then
            if y0 == 0 and y_max + y_min + 1 ~= h then
                y = (3 * y_min + y_max) // 2 - y0
            elseif y0 == h - 1 and y_max + y_min + 1 ~= h then
                y = (y_min + 3 * y_max) // 2 - y0
            else
                y = y_max + y_min - y0
            end
            if y == y0 then y = y + 1 end
            if y < 0 then y = 0 end
            if y > (h - 1) then y = h - 1 end
        else
            y = y_min
        end
    end

    print(string.format("%d %d", x, y))
end
