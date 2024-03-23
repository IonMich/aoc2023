with open("inputs/input.txt") as file:
    brick_data = file.read().split("\n")[:-1]
    num_bricks = len(brick_data)
    brick_data = (tuple(map(
        lambda y: tuple(map(
            int, tuple(y.split(",")))), x.split("~"))) 
            for x in brick_data)
    brick_data = sorted(brick_data, key=lambda x: x[0][2])
need_bricks = set()
# ground is brick -1
terrain = [[-1 for _ in range(10)] for _ in range(10)]
heights = {-1: 0}
for (b_idx, (start, end)) in enumerate(brick_data):
    sx, sy, sz = start
    ex, ey, ez = end
    if sz != ez:
        terrain_below = terrain[sx][sy]
        need_bricks.add(terrain_below)
        terrain[sx][sy] = b_idx
        heights[b_idx] = heights[terrain_below] + ez - sz + 1
        continue
    xy_coords = [(x, y) for x in range(sx, ex + 1) for y in range(sy, ey + 1)]
    max_height_bricks = set()
    max_height = -1
    for (x, y) in xy_coords:
        brick_below = terrain[x][y]
        height_below = heights[brick_below]
        if height_below > max_height:
            max_height_bricks = {brick_below,}
            max_height = height_below
        elif heights[brick_below] == max_height:
            max_height_bricks.add(brick_below)
    new_height = max_height + 1
    if len(max_height_bricks) == 1:
        brick_below = max_height_bricks.pop()
        need_bricks.add(brick_below)
    for (x, y) in xy_coords:
        terrain[x][y] = b_idx
        heights[b_idx] = new_height

need_bricks = need_bricks-{-1,}
print(num_bricks - len(need_bricks))





    
