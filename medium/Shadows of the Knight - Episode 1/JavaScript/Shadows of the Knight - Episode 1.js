/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

var inputs = readline().split(' ');
const w = parseInt(inputs[0]); // width of the building.
const h = parseInt(inputs[1]); // height of the building.
const n = parseInt(readline()); // maximum number of turns before game over. (not used)
var inputs = readline().split(' ');
var x0 = parseInt(inputs[0]);
var y0 = parseInt(inputs[1]);

var left = 0;
var right = w - 1;
var top = 0;
var bottom = h - 1;

// game loop
while (true) {
    const bombDir = readline(); // the direction of the bombs from batman's current location (U, UR, R, DR, D, DL, L or UL)

    if (bombDir.includes('U')) {
        bottom = y0 - 1;
    } else if (bombDir.includes('D')) {
        top = y0 + 1;
    }
    if (bombDir.includes('L')) {
        right = x0 - 1;
    } else if (bombDir.includes('R')) {
        left = x0 + 1;
    }

    x0 = Math.floor((left + right) / 2);
    y0 = Math.floor((top + bottom) / 2);

    // the location of the next window Batman should jump to.
    console.log(x0 + ' ' + y0);
}
