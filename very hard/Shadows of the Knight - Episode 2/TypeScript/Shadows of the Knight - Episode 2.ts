/**
 * /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 * // Function narrowDimension:                                                                                      //
 * //   Updates the search interval in one dimension                                                                  //
 * //   based on the feedback and the comparison between                                                              //
 * //   the previous position (x0 or y0) and the current position (x or y).                                           //
 * /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 */
function narrowDimension(prev: number, current: number, min: number, max: number, info: string): [number, number] {
    const sum = prev + current;

    if (info === "SAME") {
        if (sum % 2 === 0) {
            const middle = Math.floor(sum / 2);
            min = middle;
            max = middle;
        }
    } else if (info === "WARMER") {
        if (current > prev) {
            const newLower = Math.floor(sum / 2) + 1;
            if (newLower > min) min = newLower;
        } else if (current < prev) {
            const newUpper = sum % 2 === 0 ? Math.floor(sum / 2) - 1 : Math.floor(sum / 2);
            if (newUpper < max) max = newUpper;
        }
    } else if (info === "COLDER") {
        if (current > prev) {
            const newUpper = sum % 2 === 0 ? Math.floor(sum / 2) - 1 : Math.floor(sum / 2);
            if (newUpper < max) max = newUpper;
        } else if (current < prev) {
            const newLower = Math.floor(sum / 2) + 1;
            if (newLower > min) min = newLower;
        }
    }

    return [min, max];
}

/**
 * ////////////////////////////////////////////////////////////////
 * // Function narrow:                                           //
 * // Applies narrowDimension on x or y to update intervals      //
 * ////////////////////////////////////////////////////////////////
 */
function narrow(
    x0: number, y0: number, x: number, y: number,
    xMin: number, xMax: number, yMin: number, yMax: number, info: string
): [number, number, number, number] {
    console.error(`narrow: x0: ${x0} y0: ${y0} x_min: ${xMin} x_max: ${xMax} y_min: ${yMin} y_max: ${yMax} info: ${info}`);

    if (xMin !== xMax) {
        [xMin, xMax] = narrowDimension(x0, x, xMin, xMax, info);
    } else if (yMin !== yMax) {
        [yMin, yMax] = narrowDimension(y0, y, yMin, yMax, info);
    }

    console.error(`narrow : x_min: ${xMin} x_max: ${xMax} y_min: ${yMin} y_max: ${yMax}`);
    return [xMin, xMax, yMin, yMax];
}

// Initial input parsing
let inputs: string[] = readline().split(' ');
const w: number = parseInt(inputs[0]);
const h: number = parseInt(inputs[1]);
const _n: number = parseInt(readline()); // unused
inputs = readline().split(' ');
let x0: number = parseInt(inputs[0]);
let y0: number = parseInt(inputs[1]);
let x: number = x0;
let y: number = y0;

let xMin: number = 0;
let xMax: number = w - 1;
let yMin: number = 0;
let yMax: number = h - 1;

while (true) {
    let info: string = readline();

    [xMin, xMax, yMin, yMax] = narrow(x0, y0, x, y, xMin, xMax, yMin, yMax, info);

    console.error(`narrow results: x_min: ${xMin} x_max: ${xMax} y_min: ${yMin} y_max: ${yMax}`);

    x0 = x;
    y0 = y;

    if (xMin !== xMax) {
        if (x0 === 0 && xMax + xMin + 1 !== w) {
            x = Math.floor((3 * xMin + xMax) / 2) - x0;
        } else if (x0 === w - 1 && xMax + xMin + 1 !== w) {
            x = Math.floor((xMin + 3 * xMax) / 2) - x0;
        } else {
            x = xMax + xMin - x0;
        }

        if (x === x0) x++;
        x = Math.max(0, Math.min(w - 1, x));
    } else {
        if (x !== xMin) {
            x = xMin;
            x0 = x;
            console.log(`${x} ${y}`);
            info = readline();
        }

        if (yMin !== yMax) {
            if (y0 === 0 && yMax + yMin + 1 !== h) {
                y = Math.floor((3 * yMin + yMax) / 2) - y0;
            } else if (y0 === h - 1 && yMax + yMin + 1 !== h) {
                y = Math.floor((yMin + 3 * yMax) / 2) - y0;
            } else {
                y = yMax + yMin - y0;
            }

            if (y === y0) y++;
            y = Math.max(0, Math.min(h - 1, y));
        } else {
            y = yMin;
        }
    }

    console.log(`${x} ${y}`);
}
