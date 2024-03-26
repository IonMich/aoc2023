import sympy as sp

with open("inputs/input.txt") as file:
    phase_space_data = file.read().split("\n")[:-1]

num_particles = len(phase_space_data)
phase_space_data = [tuple(map(
    lambda y: tuple(map(
        int, tuple(y.split(", ")))), x.split(" @ "))) 
        for x in phase_space_data]

n_dims = len(phase_space_data[0][0])

pos_x, pos_y, pos_z = sp.symbols("pos_x pos_y pos_z", integer=True)
vel_x, vel_y, vel_z = sp.symbols("vel_x vel_y vel_z", integer=True)
pos = sp.Matrix([pos_x, pos_y, pos_z])
vel = sp.Matrix([vel_x, vel_y, vel_z])
eqs = []
times = []
for i in range(num_particles):
    r_i, v_i = phase_space_data[i]
    time = sp.symbols(f"time_{i}", positive=True, integer=True)
    times.append(time)
    for j in range(n_dims):
        eqs.append(
            sp.Eq(r_i[j] + v_i[j]*time, pos[j] + vel[j]*time)
        )
sol = sp.solve(eqs, (pos_x, pos_y, pos_z, vel_x, vel_y, vel_z, *times))
print(sum(sol[0][:3]))