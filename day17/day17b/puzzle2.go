package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func parseInputFile(fullPath string) (matrix2d [][]int) {
	file, err := os.Open(fullPath)
	check(err)
	defer file.Close()

	var row int
	for {
		var line string
		_, err := fmt.Fscanln(file, &line)
		if err != nil {
			break
		}
		slice := strings.Split(line, "")
		var intSlice []int
		for _, s := range slice {
			i, err := strconv.Atoi(s)
			check(err)
			intSlice = append(intSlice, i)
		}
		matrix2d = append(matrix2d, intSlice)
		row++
	}
	return matrix2d
}

func dijkstra(matrix2d [][]int, start [2]int, end [2]int) (int, [][2]int) {
	to_review := [][4]int{}
	distance := make(map[[4]int]int)
	prev := make(map[[4]int][4]int)
	max_i, max_j := len(matrix2d), len(matrix2d[0])
	max_distance := max_i * max_j * 9
	start_gen_coords := [4]int{start[0], start[1], 0, 0}
	distance[start_gen_coords] = 0
	to_review = append(to_review, start_gen_coords)
	for len(to_review) > 0 {
		min_distance := max_distance
		var current [4]int
		// get best node
		for node_idx := range to_review {
			node := to_review[node_idx]
			if distance[node] < min_distance {
				min_distance = distance[node]
				current = node
			}
		}
		for i, node := range to_review {
			if node == current {
				to_review = append(to_review[:i], to_review[i+1:]...)
				break
			}
		}
		if current[0] == end[0] && current[1] == end[1] {
			return distance[current], generatePath(prev, distance, start, end)
		}

		all_dirs := [][2]int{{0, 1}, {1, 0}, {0, -1}, {-1, 0}}
		entered_dir := [2]int{current[2], current[3]}
		// always turn!
		var dirs = [][2]int{}
		for _, dir := range all_dirs {
			if (dir == entered_dir) ||
				(dir == [2]int{-entered_dir[0], -entered_dir[1]}) {
				continue
			} else {
				dirs = append(dirs, dir)
			}
		}
		for _, dir := range dirs {
			temp_distance := distance[current]
			min_steps := 4
			max_steps := 10
			for step := 1; step <= max_steps; step++ {
				var next = [4]int{current[0] + dir[0]*step, current[1] + dir[1]*step, dir[0], dir[1]}
				if next[0] < 0 || next[0] >= max_i || next[1] < 0 || next[1] >= max_j {
					break
				}
				temp_distance += matrix2d[next[0]][next[1]]
				if _, ok := distance[next]; !ok {
					distance[next] = max_distance
				}
				if step < min_steps {
					continue
				}
				if temp_distance < distance[next] {
					distance[next] = temp_distance
					prev[next] = current
					to_review = append(to_review, next)
				}
			}
		}
	}
	return -1, [][2]int{}
}

func generatePath(prev map[[4]int][4]int, distance map[[4]int]int, start [2]int, end [2]int) [][2]int {
	max_distance := 1000000
	best_distance := max_distance
	best_end_node := [4]int{-1, -1, 0, 0}
	for node := range distance {
		if node[0] == end[0] && node[1] == end[1] {
			if distance[node] < best_distance {
				best_distance = distance[node]
				best_end_node = node
			}
		}
	}
	reversed_path := make([][4]int, 0)
	for node := best_end_node; node != [4]int{-1, -1, 0, 0}; node = prev[node] {
		// generate all nodes in the line segment reversed_path[len(reversed_path)-1] -> node
		var new_nodes = [][4]int{}
		if len(reversed_path) != 0 {
			var temp_end_node = reversed_path[len(reversed_path)-1]
			var dir = [2]int{temp_end_node[2], temp_end_node[3]}
			for n := temp_end_node; n[0] != node[0] || n[1] != node[1]; n = [4]int{n[0] - dir[0], n[1] - dir[1], dir[0], dir[1]} {
				if n == temp_end_node {
					continue
				}
				new_nodes = append(new_nodes, n)
			}
		}
		new_nodes = append(new_nodes, node)
		reversed_path = append(reversed_path, new_nodes...)
		if node[0] == start[0] && node[1] == start[1] {
			break
		}
	}
	path := make([][2]int, 0)
	for i := len(reversed_path) - 1; i >= 0; i-- {
		path = append(path, [2]int{reversed_path[i][0], reversed_path[i][1]})
	}
	return path
}

func visualize_path_ascii(matrix2d [][]int, path [][2]int) {
	asci_matrix := make([][]string, len(matrix2d))

	for i := range asci_matrix {
		asci_matrix[i] = make([]string, len(matrix2d[0]))
	}

	for i, row := range matrix2d {
		for j, value := range row {
			asci_matrix[i][j] = strconv.Itoa(value)
		}
	}

	for _, coords := range path {
		asci_matrix[coords[0]][coords[1]] = "X"
	}

	for _, row := range asci_matrix {
		for _, value := range row {
			// in red, if it's part of the path
			if value == "X" {
				fmt.Printf("\033[31m%s\033[0m", value)
			} else {
				fmt.Print(value)
			}
		}
		fmt.Println()
	}
}

func main() {
	matrix2d := parseInputFile("../inputs/test_input.txt")
	// for _, row := range matrix2d {
	// 	fmt.Println(row)
	// }
	start := [2]int{0, 0}
	max_i := len(matrix2d)
	max_j := len(matrix2d[0])
	end := [2]int{max_i - 1, max_j - 1}
	distance, path := dijkstra(matrix2d, start, end)
	visualize_path_ascii(matrix2d, path)
	fmt.Println(distance)
}
