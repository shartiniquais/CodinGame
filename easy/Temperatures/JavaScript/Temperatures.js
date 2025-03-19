/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

const n = parseInt(readline()); // the number of temperatures to analyse

if (n === 0) {
    console.log(0);
    return;
}

// variable to store all temperatures
let values = readline().split(' ').map(Number);

let min_value = values[0];
let min_distance = Math.abs(min_value);

for (let i = 1; i < n; i++) {
    let distance = Math.abs(values[i]);

    if (distance < min_distance || (distance === min_distance && values[i] > min_value)) {
        min_value = values[i];
        min_distance = distance;
    }
}

console.log(min_value);
