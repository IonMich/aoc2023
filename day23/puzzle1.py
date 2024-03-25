from collections import deque
dirs = {
    ">": (0, 1),
    "<": (0, -1),
    "^": (-1, 0),
    "v": (1, 0)
}
with open("inputs/input.txt") as file:
    maze = file.read().split("\n")[:-1]

num_rows = len(maze)
num_cols = len(maze[0])
maze = tuple(map(tuple, maze))
maze_start = (0, 1)
maze_end = (len(maze) - 1, len(maze[-1]) - 2)
    
def to_next_intersection(maze, start, init_dir="v", finish=maze_end):
    head = (start[0] + dirs[init_dir][0], start[1] + dirs[init_dir][1])
    nodes = deque([(head, 1)])
    seen = {start}
    while nodes:
        node = nodes.popleft()
        if node in seen:
            continue
        seen.add(node)
        if node[0] == finish:
            return node[0], node[1], []
        row, col = node[0]
        dist = node[1]
        heads = []
        for dir_char, dir in dirs.items():
            new_node = (row + dir[0], col + dir[1])
            new_char = maze[new_node[0]][new_node[1]]
            if new_node[0] < 0 or new_node[0] >= num_rows or new_node[1] < 0 or new_node[1] >= num_cols:
                continue
            if new_char == "#" or (new_char in dirs and new_char != dir_char):
                continue
            if dir_char == maze[new_node[0]][new_node[1]]:
                heads.append(dir_char)
            if new_node in seen:
                continue
            nodes.append((new_node, dist + 1))
        if len(heads) > 1:
            return (row, col), dist, heads
        
    return None

def create_graph_segment(maze, start, dir):
    end, dist, heads = to_next_intersection(maze, start, dir)
    return end, dist, heads

def create_graph(maze, start, dir):
    graph = {}
    seen = set()
    start_nodes = [(start, dir)]
    while start_nodes:
        start_node = start_nodes.pop()
        if start_node in seen:
            continue
        seen.add(start_node)
        end, dist, heads = create_graph_segment(maze, *start_node)
        graph[start_node[0]] = graph.get(start_node[0], []) + [(end, dist)]
        for head in heads:
            start_nodes.append((end, head))
    return graph

def brute_force_graph_longest_path(maze, start, dir):
    graph = create_graph(maze, start, dir)
    all_paths = []
    nodes = deque([(start, 0, [])])
    for node in graph[start]:
        nodes.append((node[0], node[1], [node[0]]))
    while nodes:
        node = nodes.popleft()
        if node[0] == maze_end:
            all_paths.append(node)
            continue
        for next_node in graph[node[0]]:
            if next_node[0] in node[2]:
                continue
            nodes.append((next_node[0], node[1] + next_node[1], node[2] + [next_node[0]]))

    return max(all_paths, key=lambda x: x[1])

print(brute_force_graph_longest_path(maze, maze_start, "v")[1])
