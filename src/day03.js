import { readFileSync } from 'node:fs';

const testInput = `467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..`.trim();

const input = readFileSync('./src/data/day03.txt', { encoding: 'utf8' });

const visited = Symbol('visited');

/**
 * 
 * @param {string} input 
 */
function indexInput(input) {
    const res = {};
    const rows = input.split('\n');
    for (let row = 0; row < rows.length; row++) {
        const line = rows[row];
        let col = 0;
        while (col < line.length) {
            const c = line[col];
            switch (true) {
                case !isNaN(+c): {
                    let end = col;
                    while (!isNaN(+line[end])) {
                        end++;
                    }
                    const token = {
                        type: 'number',
                        row: row,
                        col: col,
                        value: parseInt(line.substring(col, end)),
                        length: end - col,
                    }
                    for (let i = col; i < end; i++) {
                        res[key(row, i)] = token;
                    }
                    col = end;
                    break;
                }

                case c === '.': {
                    col++;
                    break;
                }

                default: {
                    const token = {
                        type: 'symbol',
                        row: row,
                        col: col,
                        value: c,
                    }
                    res[key(row, col)] = token;
                    col++;
                    break;
                }
            }
        }
    }
    return res;
}

/**
 * 
 * @param {number} row 
 * @param {number} col 
 * @returns 
 */
const key = (row, col) => `${row}-${col}`;

/**
 * 
 * @param {string} input 
 */
function part1(input) {
    const index = indexInput(input);
    let sum = 0;
    for (let item of Object.values(index)) {
        if (item.type === 'symbol') {
            for (let y = item.row - 1; y <= item.row + 1; y++) {
                for (let x = item.col - 1; x <= item.col + 1; x++) {
                    let value = index[key(y, x)];
                    if (value?.type === 'number' && !value[visited]) {
                        sum += value.value;
                        console.log(item, value);
                        value[visited] = true;
                    }
                }
            }
        }
    }
    return sum;
}

/**
 * 
 * @param {string} input 
 */
function part2(input) {
    const index = indexInput(input);
    let sum = 0;
    for (let item of Object.values(index)) {
        if (item.type === 'symbol' && item.value === '*') {
            const gearsEnd = new Set();
            for (let y = item.row - 1; y <= item.row + 1; y++) {
                for (let x = item.col - 1; x <= item.col + 1; x++) {
                    let value = index[key(y, x)];
                    if (value?.type === 'number') {
                        gearsEnd.add(value)
                    }
                }
            }
            if (gearsEnd.size === 2) {
                const [a, b] = [...gearsEnd];
                sum += a.value * b.value;
            }
        }
    }

    return sum;
}

//console.log(`Part 1: ${part1(input)}`);
console.log(`Part 2: ${part2(input)}`);