#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int w, h;
    if (scanf("%d %d", &w, &h) != 2) return 0;

    // Read the maze rows
    char **grid = (char **)malloc(h * sizeof(*grid));
    for (int i = 0; i < h; ++i) {
        grid[i] = (char *)malloc((w + 1) * sizeof(char));
        scanf("%s", grid[i]);
    }

    // Find start 'S'
    int sx = -1, sy = -1;
    for (int y = 0; y < h && sy < 0; ++y) {
        for (int x = 0; x < w; ++x) {
            if (grid[y][x] == 'S') { sx = x; sy = y; break; }
        }
    }

    // Distances initialized to -1 (unvisited)
    int total = w * h;
    int *dist = (int *)malloc(total * sizeof(int));
    for (int i = 0; i < total; ++i) dist[i] = -1;

    // BFS queue (store linear indices)
    int *q = (int *)malloc(total * sizeof(int));
    int head = 0, tail = 0;

    int start = sy * w + sx;
    dist[start] = 0;
    q[tail++] = start;

    // 4-neighborhood deltas
    const int dx[4] = { -1,  1,  0,  0 };
    const int dy[4] = {  0,  0, -1,  1 };

    // BFS with wrapping
    while (head < tail) {
        int cur = q[head++];
        int y = cur / w;
        int x = cur % w;
        int nd = dist[cur] + 1;

        for (int k = 0; k < 4; ++k) {
            int nx = (x + dx[k] + w) % w;
            int ny = (y + dy[k] + h) % h;
            if (grid[ny][nx] == '#') continue;

            int ni = ny * w + nx;
            if (dist[ni] != -1) continue;

            dist[ni] = nd;
            q[tail++] = ni;
        }
    }

    // Map for distances
    const char MAP[] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";

    // Render output
    for (int y = 0; y < h; ++y) {
        for (int x = 0; x < w; ++x) {
            char c = grid[y][x];
            if (c == '#') {
                putchar('#');
            } else {
                int d = dist[y * w + x];
                if (d == -1) putchar('.');
                else         putchar(MAP[d]);
            }
        }
        putchar('\n');
    }

    return 0;
}
