#include <bits/stdc++.h>
using namespace std;

int main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);

    int w, h;
    if (!(cin >> w >> h)) return 0;

    vector<string> grid(h);
    int sx = -1, sy = -1;

    for (int y = 0; y < h; ++y) {
        cin >> grid[y];
        if (sx < 0) {
            int pos = grid[y].find('S');
            if (pos != string::npos) { sx = pos; sy = y; }
        }
    }

    const int total = w * h;
    vector<int> dist(total, -1);

    // queue as vector with head index (faster than std::queue here)
    vector<int> q;
    q.reserve(total);
    int head = 0;

    int start = sy * w + sx;
    dist[start] = 0;
    q.push_back(start);

    const int dx[4] = { -1, 1, 0, 0 };
    const int dy[4] = {  0, 0,-1, 1 };

    // BFS with wrap-around (branching instead of modulo)
    while (head < (int)q.size()) {
        int cur = q[head++];
        int y = cur / w;
        int x = cur - y * w;
        int nd = dist[cur] + 1;

        for (int k = 0; k < 4; ++k) {
            int nx = x + dx[k];
            if (nx < 0) nx = w - 1; else if (nx == w) nx = 0;
            int ny = y + dy[k];
            if (ny < 0) ny = h - 1; else if (ny == h) ny = 0;

            if (grid[ny][nx] == '#') continue;

            int ni = ny * w + nx;
            if (dist[ni] != -1) continue;

            dist[ni] = nd;
            q.push_back(ni);
        }
    }

    static const string MAP = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";

    // Render
    string line;
    line.reserve(w);
    for (int y = 0; y < h; ++y) {
        line.clear();
        for (int x = 0; x < w; ++x) {
            char c = grid[y][x];
            if (c == '#') { line.push_back('#'); continue; }
            int d = dist[y * w + x];
            line.push_back(d == -1 ? '.' : MAP[d]);
        }
        cout << line << '\n';
    }
    return 0;
}
