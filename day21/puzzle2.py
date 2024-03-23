from collections import deque

with open("inputs/input.txt") as file:
    data = file.read().split("\n")
    map_data = [list(x) for x in data]
    map_data = map_data[:-1]
    start_loc = (None, None)
    for (i, line) in enumerate(map_data):
        for j in range(len(line)):
            if line[j] == "S":
                start_loc = (map_data.index(line), i)
                break
        if start_loc != (None, None):
            break    
    
    period = len(map_data[0])
    poly_order = 2
    points_needed = poly_order + 1
    base_steps = (period - 1)//2 - 1
    buffer = 1
    full_width = base_steps + buffer
    num_steps_list = [full_width + i * period for i in range(points_needed)]
    y_values = [0] * len(num_steps_list)
    for (idx, num_steps) in enumerate(num_steps_list):
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
            if ((i % 2 == j % 2 and num_steps % 2 == 0) or 
                (i % 2 != j % 2 and num_steps % 2 != 0)):
                count_valid += 1
            for direction in [(1, 0), (-1, 0), (0, 1), (0, -1)]:
                if map_data[(i + direction[0]) % period][(j + direction[1]) % period] != "#":
                    queue.append(((i + direction[0], j + direction[1]), steps + 1))
        y_values[idx] = count_valid

def quad_interpolator(p_0, p_1, p_2):
    def interp(x, denom_0, denom_1, denom_2):
        """Lagrange interpolation
        """
        f_x0 = x - p_0[0]
        f_x1 = x - p_1[0]
        f_x2 = x - p_2[0]
        term_0 = p_0[1] * f_x1 * f_x2 / denom_0
        term_1 = p_1[1] * f_x0 * f_x2 / denom_1
        term_2 = p_2[1] * f_x0 * f_x1 / denom_2
        return term_0 + term_1 + term_2
    denom_0 = (p_0[0] - p_1[0]) * (p_0[0] - p_2[0])
    denom_1 = (p_1[0] - p_0[0]) * (p_1[0] - p_2[0])
    denom_2 = (p_2[0] - p_0[0]) * (p_2[0] - p_1[0])
    return lambda x: interp(x, denom_0, denom_1, denom_2)

points = list(zip(range(4), y_values))

interpolator = quad_interpolator(points[0], points[1], points[2])

x_new = (26501365-full_width) / period
y_new = interpolator(x_new)
print(int(y_new))