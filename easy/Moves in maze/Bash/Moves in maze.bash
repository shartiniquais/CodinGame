MAP="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
DIRS=($(( -1 )) 0 1 0 0 $(( -1 )) 0 1)
IFS= read -r line
read -r -a parts <<< "${line}"
w=$(( parts[0] ))
h=$(( parts[1] ))
mz=()
for (( y=0; y<h; y++ )); do
    IFS= read -r line
    line="${line}"
    row=()
    for (( x=0; x<w; x++ )); do
        row+=("${line:x:1}")
    done
    mz+=("${row[@]}")
done
sx=0
sy=0
for (( y=0; y<h; y++ )); do
    for (( x=0; x<w; x++ )); do
        if [[ "${mz[$(( y * w + x ))]}" == "S" ]]; then
            sx=${x}
            sy=${y}
        fi
    done
done
dist=()
for (( y=0; y<h; y++ )); do
    row=()
    for (( x=0; x<w; x++ )); do
        row+=($(( -1 )))
    done
    dist+=("${row[@]}")
done
dist[$(( sy * w + sx ))]=0
queue_x=()
queue_y=()
queue_start=0
queue_x+=(${sx})
queue_y+=(${sy})
while (( queue_start < ${#queue_x[@]} )); do
    x=${queue_x[queue_start]}
    y=${queue_y[queue_start]}
    queue_start=$(( ( queue_start + 1 ) ))
    d=$(( ( dist[$(( y * w + x ))] + 1 ) ))
    for (( i=0; i<4; i++ )); do
        dx=${DIRS[$(( i * 2 + 0 ))]}
        dy=${DIRS[$(( i * 2 + 1 ))]}
        nx=$(( ( ( ( x + dx ) % w + w ) % w ) ))
        ny=$(( ( ( ( y + dy ) % h + h ) % h ) ))
        if [[ "${mz[$(( ny * w + nx ))]}" == "#" ]]; then
            continue
        fi
        if [[ ${dist[$(( ny * w + nx ))]} != $(( -1 )) ]]; then
            continue
        fi
        dist[$(( ny * w + nx ))]=${d}
        queue_x+=(${nx})
        queue_y+=(${ny})
    done
done
for (( y=0; y<h; y++ )); do
    output=""
    for (( x=0; x<w; x++ )); do
        if [[ "${mz[$(( y * w + x ))]}" == "#" ]]; then
            output="${output}#"
        else
            if [[ ${dist[$(( y * w + x ))]} == $(( -1 )) ]]; then
                output="${output}."
            else
                value=${dist[$(( y * w + x ))]}
                output="${output}${MAP:value:1}"
            fi
        fi
    done
    printf '%s\n' "${output}"
done