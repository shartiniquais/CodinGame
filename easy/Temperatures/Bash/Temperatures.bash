# Read the number of temperatures
read -r n

# Read the temperatures into an array
read -r -a temps

if [ "$n" -ne 0 ]; then
    min_value=${temps[0]}
    min_distance=${min_value#-}  # Absolute value of the first temperature

    for v in "${temps[@]}"; do
        dist=${v#-}  # Absolute value of `v`

        if [ "$dist" -lt "$min_distance" ] || { [ "$dist" -eq "$min_distance" ] && [ "$v" -gt "$min_value" ]; }; then
            min_value=$v
            min_distance=$dist
        fi
    done

    echo "$min_value"
else
    echo 0
fi