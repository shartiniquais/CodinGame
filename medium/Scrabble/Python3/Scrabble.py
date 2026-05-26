words=[]
for i in range(int(input())):
    words.append(input())
letters = input()

best_score = 0
best_word = ''

for word in words:
    valid = True
    for letter in word:
        if letter not in letters:
            valid = False
            break
    if not valid:
        continue
    # We can count the score of the word
    score = 0
    for letter in word:
        if letter in 'aeioulnrst':
            score += 1
        elif letter in 'dg':
            score += 2
        elif letter in 'bcmp':
            score += 3
        elif letter in 'fhvwy':
            score += 4
        elif letter in 'k':
            score += 5
        elif letter in 'jx':
            score += 8
        elif letter in 'qz':
            score += 10

    if score > best_score:
        best_score = score
        best_word = word

print(best_word)