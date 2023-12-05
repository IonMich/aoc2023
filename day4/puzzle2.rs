// open the file inputs/input.txt
// print lines
use std::fs::File;
use std::io::{BufRead, BufReader};
use std::vec::Vec;

fn main() {
    let file = File::open("inputs/input.txt").unwrap();
    let reader = BufReader::new(file);
    let lines = reader.lines();
    let mut extra_cards_queue: Vec<i32> = Vec::new();
    let mut total_cards = 0;
    for line in lines {
        let current_multiplier;
        if extra_cards_queue.len() > 0 {
            // pop the first element and use it as the current multiplier
            current_multiplier = extra_cards_queue.remove(0) + 1;
        } else {
            current_multiplier = 1;
        }
        total_cards += current_multiplier;
        let line = line.unwrap();
        let mut parts = line.split(": ");
        let winning_and_drawn = parts.nth(1).unwrap();
        let winning = winning_and_drawn.split("|").nth(0).unwrap();
        let winning: Vec<&str> = winning.split_whitespace().collect();
        let drawn = winning_and_drawn.split("|").nth(1).unwrap();
        let drawn: Vec<&str> = drawn.split_whitespace().collect();
        let this_card_matches = count_winning_numbers(&winning, &drawn);
        if this_card_matches > 0 {
            add_extra_cards_to_queue(
                &mut extra_cards_queue, 
                current_multiplier, 
                this_card_matches as usize);
        }
    }
    println!("{}", total_cards);
}

fn add_extra_cards_to_queue(extra_cards_queue: &mut Vec<i32>, amount: i32, until: usize) {
    for i in 0..until {
        if extra_cards_queue.len() <= i {
            extra_cards_queue.push(amount);
        } else {
            extra_cards_queue[i] += amount;
        }
    }
}

fn count_winning_numbers(winning_numbers: &Vec<&str>, drawn_numbers: &Vec<&str>) -> i32 {
    let mut score = 0;
    for drawn_number in drawn_numbers.iter() {
        if winning_numbers.contains(&drawn_number) {
            score += 1;
        }
    }
    score
}