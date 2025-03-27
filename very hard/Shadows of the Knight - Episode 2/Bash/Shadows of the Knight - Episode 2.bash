#!/bin/bash
# Reading the dimensions of the building and the maximum number of turns (not used).
read -r w h
read -r _

# Reading the starting position.
read -r x0 y0
x=$x0
y=$y0

# Initializing the bounds for x and y.
x_min=0
x_max=$((w - 1))
y_min=0
y_max=$((h - 1))

###############################################
# Function narrow_dimension:
#   Updates the search interval in one dimension
#   based on the feedback and the comparison between
#   the previous position (x0 or y0) and the current position (x or y).
#
# Parameters:
#   $1 : previous position on the axis (x0 or y0)
#   $2 : current position on the axis (x or y)
#   $3 : current lower bound (x_min or y_min)
#   $4 : current upper bound (x_max or y_max)
#   $5 : feedback ("WARMER", "COLDER", "SAME", "UNKNOWN")
#
# For SAME, if (x0+x) (or y0+y) is even, the bomb is
# exactly in the middle.
#
# For WARMER/COLDER, we deduce which side of the interval to keep:
#   - If x > x0 and WARMER, the bomb is to the right of the middle,
#     so new_min = ((x0+x)/2) + 1.
#   - If x > x0 and COLDER, the bomb is to the left, so new_max = (x0+x)/2 - (if even) or = (x0+x)/2 (if odd).
#
# The same reasoning applies for y.
###############################################
narrow_dimension() {
    local p=$1     # previous position (x0 or y0)
    local n=$2     # current position (x or y)
    local min=$3   # current lower bound
    local max=$4   # current upper bound
    local info=$5  # feedback

    case "$info" in
        "UNKNOWN")
            # No update.
            ;;
        "SAME")
            local sum=$(( p + n ))
            if [ $(( sum % 2 )) -eq 0 ]; then
                local mid=$(( sum / 2 ))
                min=$mid
                max=$mid
            fi
            ;;
        "WARMER")
            if [ "$n" -gt "$p" ]; then
                # Moving to the right: the bomb is to the right of the middle.
                local sum=$(( p + n ))
                local new_lower=$(( sum / 2 + 1 ))
                if [ "$new_lower" -gt "$min" ]; then
                    min=$new_lower
                fi
            elif [ "$n" -lt "$p" ]; then
                # Moving to the left: the bomb is to the left of the middle.
                local sum=$(( p + n ))
                if [ $(( sum % 2 )) -eq 0 ]; then
                    local new_upper=$(( sum / 2 - 1 ))
                else
                    local new_upper=$(( sum / 2 ))
                fi
                if [ "$new_upper" -lt "$max" ]; then
                    max=$new_upper
                fi
            fi
            ;;
        "COLDER")
            if [ "$n" -gt "$p" ]; then
                # Moving to the right but it's COLDER: the bomb is to the left.
                local sum=$(( p + n ))
                if [ $(( sum % 2 )) -eq 0 ]; then
                    local new_upper=$(( sum / 2 - 1 ))
                else
                    local new_upper=$(( sum / 2 ))
                fi
                if [ "$new_upper" -lt "$max" ]; then
                    max=$new_upper
                fi
            elif [ "$n" -lt "$p" ]; then
                # Moving to the left but it's COLDER: the bomb is to the right.
                local sum=$(( p + n ))
                local new_lower=$(( sum / 2 + 1 ))
                if [ "$new_lower" -gt "$min" ]; then
                    min=$new_lower
                fi
            fi
            ;;
    esac
    echo "$min $max"
}

###############################################
# Function narrow:
# Applies narrow_dimension on x as long as
# the horizontal interval is not reduced to a single value,
# then on y if x is already determined.
###############################################
narrow() {
    local x0=$1
    local y0=$2
    local x=$3
    local y=$4
    local x_min=$5
    local x_max=$6
    local y_min=$7
    local y_max=$8
    local info=$9

    echo "narrow: x0=${x0}, y0=${y0}, x=${x}, y=${y}, info=${info}" >&2

    if [ "$x_min" -ne "$x_max" ]; then
        read new_min new_max < <(narrow_dimension "$x0" "$x" "$x_min" "$x_max" "$info")
        x_min=$new_min
        x_max=$new_max
    else
        read new_min new_max < <(narrow_dimension "$y0" "$y" "$y_min" "$y_max" "$info")
        y_min=$new_min
        y_max=$new_max
    fi

    echo "narrow: x_min=${x_min}, x_max=${x_max}, y_min=${y_min}, y_max=${y_max}" >&2
    echo "${x_min} ${x_max} ${y_min} ${y_max}"
}

###############################################
# Main game loop.
# Perform a binary search first on the x-axis,
# then on the y-axis when x is determined.
###############################################
while true; do
    read -r info

    # Update the bounds.
    result=$(narrow "$x0" "$y0" "$x" "$y" "$x_min" "$x_max" "$y_min" "$y_max" "$info")
    echo "narrow result: $result" >&2

    read new_x_min new_x_max new_y_min new_y_max <<< "$result"
    x_min=$new_x_min
    x_max=$new_x_max
    y_min=$new_y_min
    y_max=$new_y_max

    # Update the previous position.
    x0=$x
    y0=$y

    # Binary search on the horizontal axis.
    if [ "$x_min" -ne "$x_max" ]; then
        if [ "$x0" -eq 0 ] && [ $(( x_max - x_min + 1 )) -ne "$w" ]; then
            x=$(( (3 * x_min + x_max) / 2 - x0 ))
        elif [ "$x0" -eq $((w - 1)) ] && [ $(( x_max - x_min + 1 )) -ne "$w" ]; then
            x=$(( (x_min + 3 * x_max) / 2 - x0 ))
        else
            x=$(( x_min + x_max - x0 ))
        fi

        # Avoid staying on the same move.
        if [ "$x" -eq "$x0" ]; then
            x=$(( x + 1 ))
        fi
        # Ensure x is within [0, w-1].
        if [ "$x" -lt 0 ]; then x=0; fi
        if [ "$x" -gt $((w - 1)) ]; then x=$((w - 1)); fi
    else
        # If x is fixed, ensure it matches x_min.
        if [ "$x" -ne "$x_min" ]; then
            x=$x_min
            x0=$x
            echo "$x $y"
            read -r info
        fi
        # Binary search on the vertical axis.
        if [ "$y_min" -eq "$y_max" ]; then
            y=$y_min
        else
            if [ "$y0" -eq 0 ] && [ $(( y_max - y_min + 1 )) -ne "$h" ]; then
                y=$(( (3 * y_min + y_max) / 2 - y0 ))
            elif [ "$y0" -eq $((h - 1)) ] && [ $(( y_max - y_min + 1 )) -ne "$h" ]; then
                y=$(( (y_min + 3 * y_max) / 2 - y0 ))
            else
                y=$(( y_min + y_max - y0 ))
            fi
            if [ "$y" -eq "$y0" ]; then
                y=$(( y + 1 ))
            fi
            if [ "$y" -lt 0 ]; then y=0; fi
            if [ "$y" -gt $((h - 1)) ]; then y=$((h - 1)); fi
        fi
    fi

    # Output the move to play.
    echo "$x $y"
done
