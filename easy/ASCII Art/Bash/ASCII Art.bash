# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

read -r l
read -r h
IFS= read -r t
asciiArt=()
for (( i=0; i<$h; i++ )); do
    IFS= read -r row
    asciiArt+=("$row")
done

result=()

# For each character in the text
for (( j=0; j<${#t}; j++ )); do
    char=${t:j:1}
    char=${char^^}  # Convert to uppercase
    # Calculate the index of the character in the ASCII art
    if [[ $char =~ [A-Z] ]]; then
        # Calculate the ASCII value of the character and find its position relative to 'A'
        asciiValue=$(printf '%d' "'$char")
        index=$((asciiValue - $(printf '%d' "'A")))
    else
        index=26  # Index for '?' for other characters
    fi
    
    # Build the entire string for each row
    for (( i=0; i<$h; i++ )); do
        rowPart="${asciiArt[$i]:$((index * l)):l}"
        result[$i]="${result[$i]}$rowPart"
    done
done

printf "%s\n" "${result[@]}"