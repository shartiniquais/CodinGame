import sys
from collections import deque

MAP = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
# Movement directions: up, down, left, right
DIRS = [(-1,0),(1,0),(0,-1),(0,1)]

w, h = map(int, sys.stdin.readline().split())
# Read maze lines into a 2D list of characters (strip trailing newline)
mz = [list(sys.stdin.readline().rstrip('\n')) for _ in range(h)]
# Find the coordinates of the start position 'S'
sx, sy = next((x, y) for y, row in enumerate(mz) for x, c in enumerate(row) if c == 'S')

# Distance grid initialized to -1 (unvisited)
dist = [[-1] * w for _ in range(h)]
dist[sy][sx] = 0  # Start position distance = 0

# BFS queue initialized with the start position
q = deque([(sx, sy)])

# Perform BFS
while q:
    x, y = q.popleft()
    d = dist[y][x] + 1  # Next cell's distance
    for dx, dy in DIRS:
        # Compute next position with wrapping (toroidal maze)
        nx, ny = (x + dx) % w, (y + dy) % h
        # Skip if wall or already visited
        if mz[ny][nx] == '#' or dist[ny][nx] != -1:
            continue
        dist[ny][nx] = d
        q.append((nx, ny))

# Render the final maze with distances
for y in range(h):
    print(''.join(
        '#' if mz[y][x] == '#' else '.' if dist[y][x] == -1 else MAP[dist[y][x]]
        for x in range(w)
    ))
