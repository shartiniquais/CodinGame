
from collections import deque


# checks if given coordinate is on map
def is_on_map(v, rows, cols):
    if v[0] < 0 or v[0] >= rows or v[1] < 0 or v[1] >= cols:
        return False
    return True

# gives map field neighbours that are on map
def get_neighbours(vertex, rows, cols):
    vr, vc = vertex
    first_set = {(vr - 1, vc), (vr + 1, vc), (vr, vc - 1), (vr, vc + 1)}

    return {v for v in first_set if is_on_map(v, rows, cols)}

# traces our first step from BFS path
def first_step(parent, start, n):
    v = n
    while parent[v[0]][v[1]] != start:
        v = parent[v[0]][v[1]]
    return v

# BFS algorithm for The Labyrinth game
def BFS(game_map, start, goal):

    # preparation
    queue = deque()
    colour = []
    parents = []
    rows = len(game_map)
    cols = len(game_map[0])
    for row in range(rows):
        colour.append([])
        parents.append([])
        for column in range(len(game_map[row])):
            colour[row].append(0)
            parents[row].append(None)

    colour[start[0]][start[1]] = 1

    queue.append(start)

    # algorithm loop
    while queue:
        u = queue.popleft()
        forbidden_symbols = ['#']
        if goal == '?':
            forbidden_symbols.append('C')
        neighbours = {x for x in get_neighbours(u, rows, cols) if game_map[x[0]][x[1]] not in forbidden_symbols}
        for n in neighbours:
            if colour[n[0]][n[1]] == 0:
                colour[n[0]][n[1]] = 1
                parents[n[0]][n[1]] = u
                queue.append(n)
                if game_map[n[0]][n[1]] == goal:
                    return first_step(parents, start, n)
        colour[u[0]][u[1]] = 2

    return None


def where_to_go(game_map, start, back):
    if not back:
        go_to = BFS(game_map, start, '?')
        if go_to is None:
            return BFS(game_map, start, 'C')
        return go_to
    else:
        return BFS(game_map, start, 'T')

r, c, a = [int(i) for i in input().split()]

# game loop
back = False
while True:
    kr, kc = [int(i) for i in input().split()]
    rows = []
    for i in range(r):
        rows.append(input())

    if rows[kr][kc] == 'C':
        back = True

    go_to = where_to_go(rows, (kr, kc), back)

    if go_to is None:
        # No path was found; in practice this should not happen.
        # Staying in place is a safe fallback.
        print("UP")
        continue

    if go_to[0] > kr:
        print("DOWN")
    elif go_to[0] < kr:
        print("UP")
    elif go_to[1] > kc:
        print("RIGHT")
    else:
        print("LEFT")
