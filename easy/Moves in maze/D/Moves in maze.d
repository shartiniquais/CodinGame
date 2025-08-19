import std.stdio;
import std.string;
import std.conv;
import std.array;

void main() {
    // Read w h
    auto first = readln.strip.split;
    int w = to!int(first[0]);
    int h = to!int(first[1]);

    // Read grid & find 'S' on the fly
    string[] grid;
    grid.length = h;
    int sx = -1, sy = -1;

    foreach (y; 0 .. h) {
        grid[y] = readln.strip; // no spaces in rows
        if (sx < 0) {
            auto pos = grid[y].indexOf('S'); // returns long
            if (pos >= 0) {
                sx = cast(int) pos; // cast long -> int
                sy = y;
            }
        }
    }

    // BFS setup
    int total = w * h;
    auto dist = new int[total];
    dist[] = -1;

    auto q = new int[total];
    int head = 0, tail = 0;

    int start = sy * w + sx;
    dist[start] = 0;
    q[tail++] = start;

    // 4-neighborhood deltas
    int[4] dx = [-1, 1, 0, 0];
    int[4] dy = [ 0, 0,-1, 1];

    // BFS with wrap-around (branch instead of modulo)
    while (head < tail) {
        int cur = q[head++];
        int y = cur / w;
        int x = cur - y * w;
        int nd = dist[cur] + 1;

        foreach (k; 0 .. 4) {
            int nx = x + dx[k];
            if (nx < 0) nx = w - 1; else if (nx == w) nx = 0;
            int ny = y + dy[k];
            if (ny < 0) ny = h - 1; else if (ny == h) ny = 0;

            if (grid[ny][nx] == '#') continue;

            int ni = ny * w + nx;
            if (dist[ni] != -1) continue;

            dist[ni] = nd;
            q[tail++] = ni;
        }
    }

    enum MAP = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";

    // Render
    foreach (yy; 0 .. h) {
        auto sb = appender!string();
        sb.reserve(w);
        foreach (xx; 0 .. w) {
            char c = grid[yy][xx];
            if (c == '#') {
                sb.put('#');
            } else {
                int d = dist[yy * w + xx];
                sb.put(d == -1 ? '.' : MAP[d]);
            }
        }
        writeln(sb.data);
    }
}
