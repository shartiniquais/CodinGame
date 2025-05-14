/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

const l = parseInt(readline());
const h = parseInt(readline());
const t = readline().toUpperCase();

const asciiArt = [];
for (let i = 0; i < h; i++) {
    const row = readline();
    asciiArt.push(row);
}

const result = Array(h).fill('');

t.split('').forEach((char) => {
    let index = 26;
    if (char >= 'A' && char <= 'Z') {
        index = char.charCodeAt(0) - 'A'.charCodeAt(0);
    }
    
    for (let i = 0; i < h; i++) {
        result[i] += asciiArt[i].substring(index * l, index * l + l);
    }
});

result.forEach((row) => {
    console.log(row);
});
