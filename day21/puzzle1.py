from collections import deque

with open("inputs/input.txt") as file:
    data = file.read().split("\n")
    map_data = [list(x) for x in data]
    start_loc = (None, None)
    for (i, line) in enumerate(map_data):
        for j in range(len(line)):
            if line[j] == "S":
                start_loc = (map_data.index(line), i)
                break
        if start_loc != (None, None):
            break    
    num_steps = 64
    seen = set()
    queue = deque([(start_loc, 0)])
    count_valid = 0
    while queue:
        (i, j), steps = queue.popleft()
        if steps > num_steps:
            break
        if (i, j) in seen:
            continue
        seen.add((i, j))
        if i % 2 == j % 2:
            count_valid += 1
        if i > 0 and map_data[i - 1][j] != "#":
            queue.append(((i - 1, j), steps + 1))
        if i < len(map_data) - 1 and map_data[i + 1][j] != "#":
            queue.append(((i + 1, j), steps + 1))
        if j > 0 and map_data[i][j - 1] != "#":
            queue.append(((i, j - 1), steps + 1))
        if j < len(map_data[i]) - 1 and map_data[i][j + 1] != "#":
            queue.append(((i, j + 1), steps + 1))

print(count_valid)
    

        

