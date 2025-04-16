# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

l = int(input())
h = int(input())
t = input().upper()
asciiArt = []
for i in range(h):
    row = input()
    asciiArt.append(row)

result = ["" for _ in range(h)]

# For each character in the text
for char in t:
    # Calculate the index of the character in the ASCII art
    if 'A' <= char <= 'Z':
        index = ord(char) - ord('A')  # Index from 0 to 25 for A to Z
    else:
        index = 26  # Index of '?' for other characters

    # Add the corresponding lines of the character to the output
    for i in range(h):
        result[i] += asciiArt[i][index * l:(index + 1) * l]

# Display the final result
print("\n".join(result))

