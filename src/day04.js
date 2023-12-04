import { readFileSync } from "fs";

/**
 * @typedef {Object} Card
 * @property {number} id
 * @property {number[]} winning
 * @property {number[]} mine
 * @property {number[]} included
 */
const testInput = `
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
`

/**
 * 
 * @param {string} input 
 */
function part1(input) {
    const cards = parseInput(input);
    let sum = 0;
    for (const card of cards) {
        let points = 0;
        if (card.included.length > 0) {
            points = Math.pow(2, card.included.length - 1);
        }
        sum += points;
        //console.log(`${card.id}: [${card.included}] (${points})`)
    }
    return sum;
}

/**
 * 
 * @param {string} input 
 */
function part2(input) {
    const cards = parseInput(input);
    const deck = [];
    for(let card of cards) {
        part2rule(card, cards, deck);
    }
    return deck.length;
}

/**
 * 
 * @param {Card} card 
 * @param {Card[]} cards 
 * @param {Card[]} deck 
 */
function part2rule(card, cards, deck) {
    deck.push(card);
    for (let i = card.id; i < card.included.length + card.id; i++) {
        part2rule(cards[i], cards, deck);
    }
}


/**
 * 
 * @param {string} input 
 * @returns {Card[]}
 */
function parseInput(input) {
    const res = [];
    const lines = input.split('\n');
    for (const line of lines) {
        const [card, data] = line.split(': ');
        const [_, rid] = card.split(/\s+/);
        const [rwinning, rmine] = data.split(' | ');
        const winning = rwinning.trim().split(/\s+/).map(value => parseInt(value, 10));
        const mine = rmine.trim().split(/\s+/).map(value => parseInt(value, 10));
        const included = winning.filter(card => mine.indexOf(card) > -1);
        res.push({
            id: parseInt(rid.trim()),
            winning,
            mine,
            included,
        })
    }
    return res;
}

const input = readFileSync('./src/data/day04.txt', { encoding: 'utf8' });
console.log(`Part 1 : ${part1(input.trim())}`);
console.log(`Part 2 : ${part2(input.trim())}`);