declare const __dirname: string;

import * as fs from 'fs';
import * as path from 'path';

function* cycleThroughArray(...args: any[]) {
    while (true) {
        yield* args;
    }
}
function parseLine(line: string) {
    const nodes = line.split(' = ');
    const node_source = nodes[0];
    let nodes_dest = nodes[1];
    nodes_dest = nodes_dest.replace('(', '');
    nodes_dest = nodes_dest.replace(')', '');
    const nodes_dest_split = nodes_dest.split(', ');
    const node1 = nodes_dest_split[0];
    const node2 = nodes_dest_split[1];
    return { node_source, node1, node2 };
}

function parseTables(node1Table: Map<string, string>, node2Table: Map<string, string>, lines: string[]) {
    lines.forEach((line : string) => {
        if (line === '') {
            return;
        }
        const { node_source, node1, node2 } = parseLine(line);

        node1Table.set(node_source, node1);
        node2Table.set(node_source, node2);
        // console.log(`node_source: (${node_source}) node1: (${node1}) node2: (${node2})`);
    });
}

function getNodesEndsWith(node1Table: Map<string, string>, endChar: string): string[] {
    const nodeSources: string[] = [];
    node1Table.forEach((_, key) => {
        if (key.endsWith(endChar)) {
            nodeSources.push(key);
        }
    });
    return nodeSources;
}

function gcd(a: number, b: number): number {
    if (b === 0) {
        return a;
    }
    return gcd(b, a % b);
}

function calculateLCM(cyclesNeeded: number[]) {
    return cyclesNeeded.reduce((a, b) => {
        return a * b / gcd(a, b);
    });
}

const node1Table = new Map();
const node2Table = new Map();

const inputPath = path.join(__dirname, '../inputs/input.txt');
const input = fs.readFileSync(inputPath, 'utf-8');
const lines = input.split('\n');
const moves = lines.shift();
if (moves === undefined) {
    throw new Error('No moves found');
}
const movesArray = moves.split('');
parseTables(node1Table, node2Table, lines);

// const mover = cycleThroughArray("L", "L", "R");
const mover = cycleThroughArray(...movesArray);

let nodes = getNodesEndsWith(node1Table, "A");


const cyclesNeeded = nodes.map((node) => {
    let numTotalMoves = 0;
    while (true) {
        if (node.endsWith("Z")) {
            break;
        }
        const move = mover.next().value;
        (move === "L") ? node = node1Table.get(node) : node = node2Table.get(node);
        numTotalMoves++;
    }
    return numTotalMoves;
});
console.log(calculateLCM(cyclesNeeded));