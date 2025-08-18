using System;
using System.Text;

class Program
{
    static void Main()
    {
        var first = Console.ReadLine()!.Split(' ');
        int w = int.Parse(first[0]);
        int h = int.Parse(first[1]);

        string[] grid = new string[h];
        int sx = -1, sy = -1;

        // Read grid & find start S on the fly
        for (int y = 0; y < h; y++)
        {
            string row = Console.ReadLine()!;
            grid[y] = row;
            if (sx < 0)
            {
                int x = row.IndexOf('S');
                if (x >= 0) { sx = x; sy = y; }
            }
        }

        int total = w * h;
        int[] dist = new int[total];
        for (int i = 0; i < total; i++) dist[i] = -1;

        // Ring buffer queue sized to number of cells
        int[] q = new int[total];
        int head = 0, tail = 0;

        int start = sy * w + sx;
        dist[start] = 0;
        q[tail] = start; tail++;

        // 4-neighborhood deltas
        int[] dx = { -1, 1, 0, 0 };
        int[] dy = {  0, 0,-1, 1 };

        // BFS with wrap-around (branch instead of modulo)
        while (head != tail)
        {
            int cur = q[head]; head++;
            int y = cur / w;
            int x = cur - y * w;
            int nd = dist[cur] + 1;

            for (int k = 0; k < 4; k++)
            {
                int nx = x + dx[k];
                if (nx < 0) nx = w - 1; else if (nx == w) nx = 0;
                int ny = y + dy[k];
                if (ny < 0) ny = h - 1; else if (ny == h) ny = 0;

                if (grid[ny][nx] == '#') continue;

                int ni = ny * w + nx;
                if (dist[ni] != -1) continue;

                dist[ni] = nd;
                q[tail] = ni; tail++;
            }
        }

        const string MAP = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";

        // Render
        var sb = new StringBuilder(w);
        for (int y = 0; y < h; y++)
        {
            sb.Clear();
            string row = grid[y];
            for (int x = 0; x < w; x++)
            {
                char c = row[x];
                if (c == '#') { sb.Append('#'); continue; }

                int d = dist[y * w + x];
                sb.Append(d == -1 ? '.' : MAP[d]);
            }
            Console.WriteLine(sb.ToString());
        }
    }
}
