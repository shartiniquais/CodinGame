/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

const n: number = parseInt(readline()); // the number of temperatures to analyse

if (n === 0) {
    console.log(0);
} else {

    var min: number = 5526;
    var minDist: number = 5526;

    var inputs: string[] = readline().split(' ');
    for (let i = 0; i < n; i++) {
        const t: number = parseInt(inputs[i]);// a temperature expressed as an integer ranging from -273 to 5526

        var distance: number = Math.abs(t);
        if (distance < minDist || (distance === minDist && t > 0)) {
            min = t;
            minDist = distance;
        }
    }

    // Write an answer using console.log()
    // To debug: console.error('Debug messages...');

    console.log(min);
}
