read -r w h

MAP="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

# Keep rows as strings for cheap access on render
declare -a grid

sx=-1; sy=-1

# Read maze & locate 'S' on the fly
for ((y=0; y<h; y++)); do
    IFS= read -r row
    grid[y]=$row
    # find 'S' in this row once
    if (( sx < 0 )); then
        for ((x=0; x<w; x++)); do
            # quick check without slicing full row repeatedly
            # (substring is still needed to test the single char)
            if [[ ${row:x:1} == "S" ]]; then
                sx=$x; sy=$y
                break
            fi
        done
    fi
done

# Distance grid initialized to -1
declare -a dist
total=$((w*h))
for ((i=0; i<total; i++)); do dist[i]=-1; done
start=$((sy*w + sx))
dist[start]=0

# Neighbor deltas
dx=(-1 1 0 0)
dy=(0 0 -1 1)

# Single-index BFS queue
declare -a q
head=0; tail=0
q[tail++]=$start

# BFS
while (( head < tail )); do
    cur=${q[head++]}
    y=$(( cur / w ))
    x=$(( cur - y*w ))
    nd=$(( dist[cur] + 1 ))

    # 4 neighbors
    for k in 0 1 2 3; do
        nx=$(( (x + dx[k] + w) % w ))
        ny=$(( (y + dy[k] + h) % h ))
        ni=$(( ny*w + nx ))

        # wall check: access char only once
        # read from the row string directly
        if [[ ${grid[ny]:nx:1} == "#" ]]; then
            continue
        fi
        # visited?
        if (( dist[ni] != -1 )); then
            continue
        fi

        dist[ni]=$nd
        q[tail++]=$ni
    done
done

# Render
for ((y=0; y<h; y++)); do
    row=${grid[y]}
    line=""
    for ((x=0; x<w; x++)); do
        ch=${row:x:1}
        if [[ $ch == "#" ]]; then
            line+="#"
        else
            d=${dist[$((y*w + x))]}
            if (( d == -1 )); then
                line+="."
            else
                # distances >= length(MAP) will render empty; clamp if needed
                line+="${MAP:d:1}"
            fi
        fi
    done
    echo "$line"
done
