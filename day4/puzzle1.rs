// open the file inputs/input.txt
// print lines
use std::fs::File;
use std::io::{BufRead, BufReader};
use std::vec::Vec;

fn main() {
    let file = File::open("inputs/input.txt").unwrap();
    let reader = BufReader::new(file);
    let lines = reader.lines();
    let mut total_score = 0;
    for line in lines {
        let line = line.unwrap();
        let mut parts = line.split(": ");
        let winning_and_drawn = parts.nth(1).unwrap();
        let winning = winning_and_drawn.split("|").nth(0).unwrap();
        let winning: Vec<&str> = winning.split_whitespace().collect();
        let drawn = winning_and_drawn.split("|").nth(1).unwrap();
        let drawn: Vec<&str> = drawn.split_whitespace().collect();
        let mut score = 0;
        score += count_winning_numbers(&winning, &drawn);
        total_score += score;
    }
    println!("{}", total_score);
}

fn count_winning_numbers(winning_numbers: &Vec<&str>, drawn_numbers: &Vec<&str>) -> i32 {
    let mut score = 0;
    for drawn_number in drawn_numbers.iter() {
        if winning_numbers.contains(&drawn_number) {
            if score == 0 {
                score = 1;
            } else {
                score *= 2;
            }
        }
    }
    score
}