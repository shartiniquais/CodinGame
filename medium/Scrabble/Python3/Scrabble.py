from collections import Counter

n = int(input())
words = [input() for _ in range(n)]
letters = input()

available = Counter(letters)

points = {
    letter: value
    for group, value in [
        ("aeioulnrst", 1),
        ("dg", 2),
        ("bcmp", 3),
        ("fhvwy", 4),
        ("k", 5),
        ("jx", 8),
        ("qz", 10),
    ]
    for letter in group
}

best_word = ""
best_score = 0

for word in words:
    if len(word) > len(letters):
        continue

    remaining = available.copy()
    score = 0

    for letter in word:
        if remaining[letter] == 0:
            break

        remaining[letter] -= 1
        score += points[letter]
    else:
        # This runs only if every letter in the word was available.
        if score > best_score:
            best_word = word
            best_score = score

print(best_word)