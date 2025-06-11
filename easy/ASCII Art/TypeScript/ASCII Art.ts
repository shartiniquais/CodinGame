const L: number = parseInt(readline());
const H: number = parseInt(readline());
const T: string = readline().toUpperCase();

const asciiArt = Array.from({ length: H }, () => readline());

const result: string[] = Array(H).fill('');

for (const c of T) {
    let index: number;
    if (c >= 'A' && c <= 'Z') {
        index = c.charCodeAt(0) - 'A'.charCodeAt(0);
    } else {
        index = 26;
    }

    for (let i = 0; i < H; i++) {
        result[i] += asciiArt[i].substring(index * L, (index + 1) * L);
    }
}

result.forEach(line => console.log(line));

