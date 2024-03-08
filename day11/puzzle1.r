# read file inputs/input.txt
myfile <- file("inputs/input.txt", open = "r")
lines <- readLines(myfile)
num_rows <- length(lines)
num_cols <- nchar(lines[1])
total_distance <- 0
galaxy_coords <- c()
for (i in 1:num_rows) {
  line <- lines[i]
  for (j in 1:num_cols) {
    if (substring(line, j, j) == "#") {
      galaxy_coords <- rbind(galaxy_coords, c(i, j))
    }
  }
}
tallies_rows <- galaxy_coords[, 1]
tallies_cols <- galaxy_coords[, 2]
total_galaxies <- length(tallies_rows)
empty_rows <- setdiff(1:num_rows, tallies_rows)
empty_cols <- setdiff(1:num_cols, tallies_cols)
for (row in empty_rows) {
  num_before <- sum(tallies_rows < row)
  num_after <- total_galaxies - num_before
  total_distance <- total_distance + num_before * num_after
}
for (col in empty_cols) {
  num_before <- sum(tallies_cols < col)
  num_after <- total_galaxies - num_before
  total_distance <- total_distance + num_before * num_after
}
for (i in 1:(total_galaxies - 1)) {
  for (j in (i + 1):total_galaxies) {
    row_diff <- abs(galaxy_coords[i, 1] - galaxy_coords[j, 1])
    col_diff <- abs(galaxy_coords[i, 2] - galaxy_coords[j, 2])
    total_distance <- total_distance + row_diff + col_diff
  }
}
print(total_distance)
close(myfile)
