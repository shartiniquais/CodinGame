read -r msg
output=""
bn=""
b="unset"

for (( i=0; i<${#msg}; i++ )); do
    c=${msg:$i:1}

    ascii_value=$(printf "%d" "'$c")  # get ascii value of character c
    binary_value=$(echo "obase=2;$ascii_value" | bc) # convert ascii value to binary with bc
    binary_str=$(echo $binary_value | sed 's/^0b//') # remove 0b from binary value
    padded_binary=$(printf "%07d" $binary_str) # pad binary value with 0s to make it 7 bits long
    bn+=$padded_binary
done

for (( i=0; i<${#bn}; i++ )); do
    c=${bn:$i:1}
    if [ $c -eq "1" ] && [ $b != "1" ]; then
        output+=" 0 "
        b="1"
    elif [ $c -eq "0" ] && [ $b != "0" ]; then
        output+=" 00 "
        b="0"
    fi
    output+="0"
done

# remove trailing space
output=$(echo $output | sed 's/ $//')
echo $output
