/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

/**
 * Updates the search interval in one dimension
 * based on the feedback and the comparison between
 * the previous position (x0 or y0) and the current position (x or y).
 *
 * Parameters:
 *   $1 : previous position on the axis (x0 or y0)
 *   $2 : current position on the axis (x or y)
 *   $3 : current lower bound (x_min or y_min)
 *   $4 : current upper bound (x_max or y_max)
 *   $5 : feedback ("WARMER", "COLDER", "SAME", "UNKNOWN")
 *
 * For SAME, if (x0+x) (or y0+y) is even, the bomb is
 * exactly in the middle.
 *
 * For WARMER/COLDER, we deduce which side of the interval to keep:
 *   - If x > x0 and WARMER, the bomb is to the right of the middle,
 *     so new_min = ((x0+x)/2) + 1.
 *   - If x > x0 and COLDER, the bomb is to the left, so new_max = (x0+x)/2 - (if even) or = (x0+x)/2 (if odd).
 *
 * The same reasoning applies for y.
 */
function narrow_dimension(prev, current, min, max, info) {
    if (info === "SAME") {
        const sum = prev + current;
        if (sum % 2 === 0) {
            const middle = Math.floor(sum / 2);
            min = middle;
            max = middle;
        }
    } else if (info === "WARMER") {
        const sum = prev + current;
        if (current > prev) {
            // Moving to the right: the bomb is to the right of the middle.
            const new_lower = Math.floor(sum / 2) + 1;
            if (new_lower > min) {
                min = new_lower;
            }
        } else if (current < prev) {
            // Moving to the left: the bomb is to the left of the middle.
            const new_upper = (sum % 2 === 0) ? (sum / 2 - 1) : Math.floor(sum / 2);
            if (new_upper < max) {
                max = new_upper;
            }
        }
    } else if (info === "COLDER") {
        const sum = prev + current;
        if (current > prev) {
            // Moving to the right: the bomb is to the left of the middle.
            const new_upper = (sum % 2 === 0) ? (sum / 2 - 1) : Math.floor(sum / 2);
            if (new_upper < max) {
                max = new_upper;
            }
        } else if (current < prev) {
            // Moving to the left: the bomb is to the right of the middle.
            const new_lower = Math.floor(sum / 2) + 1;
            if (new_lower > min) {
                min = new_lower;
            }
        }
    }
    return [min, max];
}

/**
 * Applies narrow_dimension on x as long as
 * the horizontal interval is not reduced to a single value,
 * then on y if x is already determined.
 */
function narrow(x0, y0, x, y, x_min, x_max, y_min, y_max, info) {
    console.error(`narrow: x0: ${x0} y0: ${y0} x_min: ${x_min} x_max: ${x_max} y_min: ${y_min} y_max: ${y_max} info: ${info}`);
    if (x_min !== x_max) {
        const [new_x_min, new_x_max] = narrow_dimension(x0, x, x_min, x_max, info);
        x_min = new_x_min;
        x_max = new_x_max;
    } else if (y_min !== y_max) {
        const [new_y_min, new_y_max] = narrow_dimension(y0, y, y_min, y_max, info);
        y_min = new_y_min;
        y_max = new_y_max;
    }
    console.error(`narrow results: x_min: ${x_min} x_max: ${x_max} y_min: ${y_min} y_max: ${y_max}`);
    return [x_min, x_max, y_min, y_max];
}

// Initial input
let inputs = readline().split(' ');
const w = parseInt(inputs[0], 10);
const h = parseInt(inputs[1], 10);

const _ = parseInt(readline(), 10); // (not used)

inputs = readline().split(' ');
let x0 = parseInt(inputs[0], 10);
let y0 = parseInt(inputs[1], 10);
let x = x0;
let y = y0;

let x_min = 0;
let x_max = w - 1;
let y_min = 0;
let y_max = h - 1;

// Game loop
while (true) {
    const info = readline();

    [x_min, x_max, y_min, y_max] = narrow(x0, y0, x, y, x_min, x_max, y_min, y_max, info);

    x0 = x;
    y0 = y;

    if (x_min !== x_max) {
        if (x0 === 0 && x_max + x_min + 1 !== w) {
            x = Math.floor((3 * x_min + x_max) / 2) - x0;
        } else if (x0 === w - 1 && x_max + x_min + 1 !== w) {
            x = Math.floor((x_min + 3 * x_max) / 2) - x0;
        } else {
            x = x_max + x_min - x0;
        }

        if (x === x0) x = x0 + 1;
        if (x < 0) x = 0;
        if (x > w - 1) x = w - 1;
    } else {
        if (x !== x_min) {
            x = x_min;
            x0 = x;
            console.log(`${x} ${y}`);
            const updatedInfo = readline();
            [x_min, x_max, y_min, y_max] = narrow(x0, y0, x, y, x_min, x_max, y_min, y_max, updatedInfo);
        }

        if (y_min !== y_max) {
            if (y0 === 0 && y_max + y_min + 1 !== h) {
                y = Math.floor((3 * y_min + y_max) / 2) - y0;
            } else if (y0 === h - 1 && y_max + y_min + 1 !== h) {
                y = Math.floor((y_min + 3 * y_max) / 2) - y0;
            } else {
                y = y_max + y_min - y0;
            }

            if (y === y0) y = y + 1;
            if (y < 0) y = 0;
            if (y > h - 1) y = h - 1;
        } else {
            y = y_min;
        }
    }

    console.log(`${x} ${y}`);
}
