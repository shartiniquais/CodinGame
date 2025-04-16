/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

var inputs: string[] = readline().split(' ');
const w: number = parseInt(inputs[0]); // width of the building.
const h: number = parseInt(inputs[1]); // height of the building.
const _: number = parseInt(readline()); // maximum number of turns before game over. (not used)
var inputs: string[] = readline().split(' ');
var x0: number = parseInt(inputs[0]);
var y0: number = parseInt(inputs[1]);

var left: number = 0;
var right: number = w - 1;
var up: number = 0;
var down: number = h - 1;

// game loop
while (true) {
    const bombDir: string = readline(); // the direction of the bombs from batman's current location (U, UR, R, DR, D, DL, L or UL)

    if (bombDir.includes('U')) {
        down = y0 - 1;
    } else if (bombDir.includes('D')) {
        up = y0 + 1;
    }
    if (bombDir.includes('L')) {
        right = x0 - 1;
    } else if (bombDir.includes('R')) {
        left = x0 + 1;
    }

    x0 = Math.floor((left + right) / 2);
    y0 = Math.floor((up + down) / 2);

    console.log(x0 + ' ' + y0);
}
