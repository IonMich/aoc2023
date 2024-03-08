const fs = require('fs');

const contents = fs.readFileSync('inputs/input.txt', 'utf8');

const lines = contents.split('\n');
lines.pop(); // Remove last empty line
const colors = ["red", "green", "blue"];
const color_max = [12, 13, 14];
let sum = 0;
lines.forEach((line, index) => {
    let foundError = false;
    for (let i = 0; i < colors.length; i++) {
        const regex_numbers = new RegExp(`\\d+(?= ${colors[i]})`, 'g');
        const numbers = line.match(regex_numbers);
        if (numbers.some((number) => number > color_max[i])) {
            foundError = true;
            break;
        }
    }
    (!foundError) && (sum += index + 1);
});
console.log(`${sum}`);
