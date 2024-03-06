"use strict";
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (g && (g = 0, op[0] && (_ = 0)), _) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
var __values = (this && this.__values) || function(o) {
    var s = typeof Symbol === "function" && Symbol.iterator, m = s && o[s], i = 0;
    if (m) return m.call(o);
    if (o && typeof o.length === "number") return {
        next: function () {
            if (o && i >= o.length) o = void 0;
            return { value: o && o[i++], done: !o };
        }
    };
    throw new TypeError(s ? "Object is not iterable." : "Symbol.iterator is not defined.");
};
Object.defineProperty(exports, "__esModule", { value: true });
var fs = require("fs");
var path = require("path");
function cycleThroughArray() {
    var _i;
    var args = [];
    for (_i = 0; _i < arguments.length; _i++) {
        args[_i] = arguments[_i];
    }
    return __generator(this, function (_a) {
        switch (_a.label) {
            case 0:
                if (!true) return [3 /*break*/, 2];
                return [5 /*yield**/, __values(args)];
            case 1:
                _a.sent();
                return [3 /*break*/, 0];
            case 2: return [2 /*return*/];
        }
    });
}
function parseLine(line) {
    var nodes = line.split(' = ');
    var node_source = nodes[0];
    var nodes_dest = nodes[1];
    nodes_dest = nodes_dest.replace('(', '');
    nodes_dest = nodes_dest.replace(')', '');
    var nodes_dest_split = nodes_dest.split(', ');
    var node1 = nodes_dest_split[0];
    var node2 = nodes_dest_split[1];
    return { node_source: node_source, node1: node1, node2: node2 };
}
function parseTables(node1Table, node2Table, lines) {
    lines.forEach(function (line) {
        if (line === '') {
            return;
        }
        var _a = parseLine(line), node_source = _a.node_source, node1 = _a.node1, node2 = _a.node2;
        node1Table.set(node_source, node1);
        node2Table.set(node_source, node2);
        // console.log(`node_source: (${node_source}) node1: (${node1}) node2: (${node2})`);
    });
}
function getNodesEndsWith(node1Table, endChar) {
    var nodeSources = [];
    node1Table.forEach(function (_, key) {
        if (key.endsWith(endChar)) {
            nodeSources.push(key);
        }
    });
    return nodeSources;
}
function gcd(a, b) {
    if (b === 0) {
        return a;
    }
    return gcd(b, a % b);
}
function calculateLCM(cyclesNeeded) {
    return cyclesNeeded.reduce(function (a, b) {
        return a * b / gcd(a, b);
    });
}
var node1Table = new Map();
var node2Table = new Map();
var inputPath = path.join(__dirname, '../inputs/input.txt');
var input = fs.readFileSync(inputPath, 'utf-8');
var lines = input.split('\n');
var moves = lines.shift();
if (moves === undefined) {
    throw new Error('No moves found');
}
var movesArray = moves.split('');
parseTables(node1Table, node2Table, lines);
// const mover = cycleThroughArray("L", "L", "R");
var mover = cycleThroughArray.apply(void 0, movesArray);
var nodes = getNodesEndsWith(node1Table, "A");
var cyclesNeeded = nodes.map(function (node) {
    var numTotalMoves = 0;
    while (true) {
        if (node.endsWith("Z")) {
            break;
        }
        var move = mover.next().value;
        (move === "L") ? node = node1Table.get(node) : node = node2Table.get(node);
        numTotalMoves++;
    }
    return numTotalMoves;
});
console.log(calculateLCM(cyclesNeeded));
