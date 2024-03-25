with open("inputs/input.txt") as file:
    phase_space_data = file.read().split("\n")[:-1]

num_particles = len(phase_space_data)
phase_space_data = [tuple(map(
    lambda y: tuple(map(
        int, tuple(y.split(", ")))), x.split(" @ "))) 
        for x in phase_space_data]

def get_2d_ray_intersection(state_1, state_2):
    (x1, y1, _), (vx1, vy1, _) = state_1
    (x2, y2, _), (vx2, vy2, _) = state_2
    if (vx1*vy2 == vy1*vx2) and ((vx1*vx2 > 0 and vy1*vy2 > 0) or (vx1*vx2 < 0 and vy1*vy2 < 0)):
        return None
    y_int = (x1 - x2 - y1 * vx1/vy1 + y2 * vx2/vy2) / (vx2/vy2 - vx1/vy1)
    x_int = x1 + vx1/vy1 * (y_int - y1)
    is_past = False
    if (x_int-x1)*vx1 < 0 or (y_int-y1)*vy1 < 0:
        is_past = True
    if (x_int-x2)*vx2 < 0 or (y_int-y2)*vy2 < 0:
        is_past = True
    if is_past:
        return None
    return (x_int, y_int)

def is_in_box(intersection, box):
    x, y = intersection
    (x1, y1), (x2, y2) = box
    return x1 < x < x2 and y1 < y < y2

num_intersections = 0
# min_xy = 7
# max_xy = 27
min_xy = 200000000000000
max_xy = 400000000000000
for i in range(num_particles):
    for j in range(i+1, num_particles):
        intersection = get_2d_ray_intersection(phase_space_data[i], phase_space_data[j])
        if (intersection is not None) and is_in_box(intersection, ((min_xy, min_xy), (max_xy, max_xy))):
            num_intersections += 1
print(num_intersections)