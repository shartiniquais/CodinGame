msg = input()
out = ""
bn = ""
b = ""

for c in msg:
    ascii_value = ord(c)         # Get ASCII value of the character
    binary_value = bin(ascii_value)  # Convert to binary (includes '0b' prefix)
    binary_str = binary_value[2:]    # Remove the '0b' prefix
    padded_binary = binary_str.zfill(7)  # Zero-pad to 7 bits
    bn += padded_binary

for c in bn:
    if c == "1" != b:
        out += " 0 "
        b = "1"
    elif c == "0" != b:
        out += " 00 "
        b = "0"
    out += "0"

print(out.strip())
