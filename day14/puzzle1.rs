use std::fs::File;
use std::io::{BufRead, BufReader};
use std::vec::Vec;

fn process_line(line: &str, ceilings: &mut Vec<i32>, current_depth: i32) -> (i32, i32) {
    let rocks = line.split("").filter(|&x| x != "");
    let mut line_weight = 0;
    let mut contributions = 0;
    for (j, rock) in rocks.enumerate() {
        match rock {
            "O" => {
                line_weight += ceilings[j];
                contributions += 1;
                ceilings[j] -= 1;
            }
            "#" => {
                ceilings[j] = current_depth-1;
            }
            _ => {}
        }
    }
    (line_weight, contributions)
}

fn get_line_width(line: &str) -> usize {
    line.chars().count() as usize
}

fn main() {
    let file = File::open("inputs/input.txt").unwrap();
    let reader = BufReader::new(file);
    let lines = reader.lines();
    let mut line_width = 0;
    let mut total_weight = 0;
    let mut height = 1;
    let mut contributions = 0;
    let mut ceilings = vec![0; line_width];
    for (i, line) in lines.enumerate() {
        let line = line.unwrap();
        if line == "" {
            break;
        }
        if i == 0 {
            line_width = get_line_width(&line);
            ceilings = vec![0; line_width];
        }
        let current_depth = -(i as i32);
        let (line_weight, line_contributions) = process_line(&line, &mut ceilings, current_depth);
        total_weight += line_weight;
        contributions += line_contributions;
        height = i+1;
    }
    println!("{}", total_weight + contributions*(height as i32));
}
