read -r w h
read -r _ # maximum number of turns (not used)
read -r x0 y0

left=0
right=$((w - 1))
top=0
bottom=$((h - 1))


# game loop
while true; do
    # bombDir: the direction of the bombs from batman's current location (U, UR, R, DR, D, DL, L or UL)
    read -r bombDir

    if [[ "$bombDir" == *"U"* ]]; then
        bottom=$((y0 - 1))
    elif [[ "$bombDir" == *"D"* ]]; then
        top=$((y0 + 1))
    fi
    if [[ "$bombDir" == *"L"* ]]; then
        right=$((x0 - 1))
    elif [[ "$bombDir" == *"R"* ]]; then
        left=$((x0 + 1))
    fi

    # new position
    x0=$(( (left + right) / 2 ))
    y0=$(( (top + bottom) / 2 ))

    echo "$x0 $y0"
done