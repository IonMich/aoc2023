use std::fs::{File};
use std::io::{BufRead, BufReader};
use std::vec::Vec;

const ROUND_ROCK: i8 = 1;
const SQUARE_ROCK: i8 = 2;

fn get_rock_matrix(file: File) -> Vec<Vec<i8>> {
    let reader = BufReader::new(file);
    let lines = reader.lines();
    let mut line_width = 0;
    let mut rock_matrix = Vec::new();
    for (i, line) in lines.enumerate() {
        let line = line.unwrap();
        if line == "" { break; }
        if i == 0 {
            line_width = get_line_width(&line);
        }
        let rock_vec = get_rock_vec(&line, line_width);
        rock_matrix.push(rock_vec);
    }
    rock_matrix
}

fn get_rock_vec(line: &str, line_width: usize) -> Vec<i8> {
    let mut rock_binary_vec = vec![0; line_width];
    let rocks = line.split("").filter(|&x| x != "");
    for (j, rock) in rocks.enumerate() {
        match rock {
            "O" => rock_binary_vec[j] = ROUND_ROCK,
            "#" => rock_binary_vec[j] = SQUARE_ROCK,
            _ => {}
        }
    }
    rock_binary_vec
}

fn get_line_width(line: &str) -> usize {
    line.chars().count() as usize
}

fn shift_round_rocks_left_in_line(rock_vec: &Vec<i8>) -> Vec<i8> {
    let mut new_rock_vec = rock_vec.clone();
    let mut j = 0;
    for (i, rock) in rock_vec.iter().enumerate() {
        match rock {
            &ROUND_ROCK => (new_rock_vec[i], new_rock_vec[j], j) =
                (0, new_rock_vec[i], j + 1),
            &SQUARE_ROCK => j = i + 1,
            _ => {}
        }
    }
    new_rock_vec
}

fn shift_matrix_left(rock_matrix: &Vec<Vec<i8>>) -> Vec<Vec<i8>> {
    let mut new_rock_matrix = Vec::new();
    for rock_vec in rock_matrix.iter() {
        let new_rock_vec = shift_round_rocks_left_in_line(&rock_vec);
        new_rock_matrix.push(new_rock_vec);
    }
    new_rock_matrix
}

fn rot90left(rock_matrix: &Vec<Vec<i8>>) -> Vec<Vec<i8>> {
    let mut new_rock_matrix = Vec::new();
    for i in (0..rock_matrix[0].len()).rev() {
        let mut new_rock_vec = Vec::new();
        for j in 0..rock_matrix.len() {
            new_rock_vec.push(rock_matrix[j][i]);
        }
        new_rock_matrix.push(new_rock_vec);
    }
    new_rock_matrix
}

fn rot90right(rock_matrix: &Vec<Vec<i8>>) -> Vec<Vec<i8>> {
    let mut new_rock_matrix = Vec::new();
    for i in 0..rock_matrix[0].len() {
        let mut new_rock_vec = Vec::new();
        for j in (0..rock_matrix.len()).rev() {
            new_rock_vec.push(rock_matrix[j][i]);
        }
        new_rock_matrix.push(new_rock_vec);
    }
    new_rock_matrix
}

fn rot90left_shift_left(rock_matrix: &Vec<Vec<i8>>) -> Vec<Vec<i8>> {
    let new_rock_matrix = rot90left(rock_matrix);
    shift_matrix_left(&new_rock_matrix)
}

fn rot90right_shift_left(rock_matrix: &Vec<Vec<i8>>) -> Vec<Vec<i8>> {
    let new_rock_matrix = rot90right(rock_matrix);
    shift_matrix_left(&new_rock_matrix)
}

fn rot_shift_full_cycle(rock_matrix: &Vec<Vec<i8>>) -> Vec<Vec<i8>> {
    let mut new_rock_matrix = rot90left_shift_left(&rock_matrix);
    for _ in 0..3 {
        new_rock_matrix = rot90right_shift_left(&new_rock_matrix);
    }
    new_rock_matrix = rot90right(&new_rock_matrix);
    new_rock_matrix = rot90right(&new_rock_matrix);
    new_rock_matrix
}

fn rot_shift_n_cycles(rock_matrix: &Vec<Vec<i8>>, n: i32, sum_sequence: &mut Vec<i32>, iter_sequence: &mut Vec<i32>) -> Vec<Vec<i8>> {
    let mut new_rock_matrix = rock_matrix.clone();
    let mut matrix_after_burnin = Vec::new();
    let burn_in = 500;
    for _iter in 1..n {
        new_rock_matrix = rot_shift_full_cycle(&new_rock_matrix);
        if _iter < burn_in { continue; }
        if new_rock_matrix == matrix_after_burnin { break; }
        if matrix_after_burnin.len() == 0 {
            matrix_after_burnin = new_rock_matrix.clone();
        }
        sum_sequence.push(sum_round_rocks(&new_rock_matrix));
        iter_sequence.push(_iter);
    }
    new_rock_matrix
}

fn line_sum_round_rocks(rock_matrix: &Vec<i8>) -> i32 {
    let mut sum = 0;
    for rock in rock_matrix.iter() {
        if *rock == ROUND_ROCK {
            sum += 1;
        }
    }
    sum
}

fn sum_round_rocks(rock_matrix: &Vec<Vec<i8>>) -> i32 {
    let mut row_sums = Vec::new();
    for rock_vec in rock_matrix.iter() {
        let line_sum = line_sum_round_rocks(&rock_vec);
        row_sums.push(line_sum);
    }
    let mut sum = 0;
    for (i, row_sum) in row_sums.iter().enumerate() {
        sum += row_sum * (rock_matrix.len() - i) as i32;
    }
    sum
}

fn main() {
    let file = File::open("inputs/input.txt").expect("File not found");
    let rock_matrix = get_rock_matrix(file);
    let num_cycles = 10000;
    let mut sum_sequence = Vec::new();
    let mut iter_sequence = Vec::new();
    _ = rot_shift_n_cycles(&rock_matrix, num_cycles, &mut sum_sequence, &mut iter_sequence);
    
    let target_iter = 1000000000;
    let cycle_length = iter_sequence.len() as i32;
    let cycle_start = iter_sequence[0];
    let sum_at_target_iter = sum_sequence[(target_iter - cycle_start) as usize % cycle_length as usize];
    println!("{}", sum_at_target_iter);
}
