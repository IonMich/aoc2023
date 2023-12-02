const fs = require('fs');

const contents = fs.readFileSync('inputs/input.txt', 'utf8');

const lines = contents.split('\n');
lines.pop(); // Remove last empty line
const colors = ["red", "green", "blue"];
let sum = 0;
lines.forEach((line) => {
    const product = colors.reduce((acc, color) => {
        const regex_numbers = new RegExp(`\\d+(?= ${color})`, 'g');
        const numbers = line.match(regex_numbers);
        const maxNum = Math.max(...numbers);
        return acc * maxNum;
    }, 1);
    sum += product;
});
console.log(`${sum}`);