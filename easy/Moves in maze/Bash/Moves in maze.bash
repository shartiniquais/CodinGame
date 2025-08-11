read -r w h

MAP="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

dirs=("-1,0" "1,0" "0,-1" "0,1")

declare -a grid # array to hold maze rows
# Read maze lines
for ((y=0; y<h; y++)); do
    IFS= read -r row
    for ((x=0; x<w; x++)); do
        idx=$((y*w + x))
        grid[idx]="${row:x:1}"
    done
done

# Find sx and sy
sx=-1; sy=-1; found=0
for ((y=0; y<h && !found; y++)); do
    for ((x=0; x<w; x++)); do
        idx=$((y*w + x))
        if [[ "${grid[idx]}" == "S" ]]; then
            sx=$x; sy=$y; found=1
            break
        fi
    done
done

# Distance grid initialized to -1 (unvisited)
declare -a dist
for ((i=0; i<${#grid[@]}; i++)); do
    dist[i]=-1
done
dist[$((sy*w + sx))]=0  # Start position distance = 0

# BFS queue initialized with the start position
declare -a qx qy
head=0; tail=0

# Enqueue start
qx[tail]=$sx
qy[tail]=$sy
((tail++))

# Perform BFS
while (( head < tail )); do
    x=${qx[head]}
    y=${qy[head]}
    ((head++))

    cur=$((y*w + x))
    d=$((dist[cur] + 1))

    for pair in "${dirs[@]}"; do
        IFS=',' read -r dx dy <<< "$pair"

        # Compute next position with wrapping
        nx=$(( (x + dx + w) % w ))
        ny=$(( (y + dy + h) % h ))

        idx=$((ny*w + nx))

        # Skip if wall or already visited
        if [[ "${grid[idx]}" == "#" ]]; then
            continue
        fi
        if (( dist[idx] != -1 )); then
            continue
        fi


        dist[idx]=$d
        qx[tail]=$nx
        qy[tail]=$ny
        ((tail++))
    done
done

# Render the final maze with distances
for ((y=0; y<h; y++)); do
    line=""
    for ((x=0; x<w; x++)); do
        idx=$((y*w + x))
        if [[ "${grid[idx]}" == "#" ]]; then
            ch="#"
        else
            d=${dist[idx]}
            if (( d == -1 )); then
                ch="."
            else
                ch="${MAP:d:1}"
            fi
        fi
    line+="$ch"
    done
    echo "$line"
done