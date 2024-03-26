# solution that impliments
# https://www.reddit.com/r/adventofcode/comments/18qbsxs/comment/ketzp94/?utm_source=share&utm_medium=web2x&context=3
with open("inputs/input.txt") as file:
    graph_data = file.read().split("\n")[:-1]

graph_data = [tuple(map(
    lambda y: 
        tuple(y.split(" ")), x.split(": "))) 
        for x in graph_data]

connections = {}
for datum in graph_data:
    base = datum[0][0]
    for dest in datum[1]:
        base_connections = connections.get(base, set())
        base_connections.add(dest)
        connections[base] = base_connections
        dest_connections = connections.get(dest, set())
        dest_connections.add(base)
        connections[dest] = dest_connections

all_nodes = {node for node in connections.keys()}
len_nodes = len(all_nodes)
group1 = all_nodes.copy()
group2 = set()

def count_not_in_group(node, group):
    nodes_not_in_group = connections[node] - group
    return len(nodes_not_in_group)

def get_outer_node(group):
    max_count = -1
    node = None
    for n in group:
        count = count_not_in_group(n, group)
        if count > max_count:
            max_count = count
            node = n
    return node

def get_ext_connections_count(group):
    count = 0
    for node in group:
        count += count_not_in_group(node, group)
    return count

while len(group1) > 0:
    node = get_outer_node(group1)
    group1.remove(node)
    group2.add(node)
    if get_ext_connections_count(group1) == 3:
        print(len(group1) * (len_nodes - len(group1)))
