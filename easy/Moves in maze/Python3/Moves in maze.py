import sys

MAP = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

DIRS = [
    [-1, 0],
    [1, 0],
    [0, -1],
    [0, 1]
]

# Read width and height
line = sys.stdin.readline()
parts = line.split()
w = int(parts[0])
h = int(parts[1])

# Read maze
mz = []

for y in range(h):
    line = sys.stdin.readline()
    line = line.rstrip("\n")

    row = []
    for x in range(w):
        row.append(line[x])

    mz.append(row)

# Find start position
sx = 0
sy = 0

for y in range(h):
    for x in range(w):
        if mz[y][x] == "S":
            sx = x
            sy = y

# Create distance grid
dist = []

for y in range(h):
    row = []

    for x in range(w):
        row.append(-1)

    dist.append(row)

dist[sy][sx] = 0

# Queue implementation without deque
queue_x = []
queue_y = []
queue_start = 0

queue_x.append(sx)
queue_y.append(sy)

# BFS
while queue_start < len(queue_x):
    x = queue_x[queue_start]
    y = queue_y[queue_start]
    queue_start = queue_start + 1

    d = dist[y][x] + 1

    for i in range(4):
        dx = DIRS[i][0]
        dy = DIRS[i][1]

        nx = (x + dx) % w
        ny = (y + dy) % h

        if mz[ny][nx] == "#":
            continue

        if dist[ny][nx] != -1:
            continue

        dist[ny][nx] = d

        queue_x.append(nx)
        queue_y.append(ny)

# Render result
for y in range(h):
    output = ""

    for x in range(w):
        if mz[y][x] == "#":
            output = output + "#"
        else:
            if dist[y][x] == -1:
                output = output + "."
            else:
                value = dist[y][x]
                output = output + MAP[value]

    print(output)