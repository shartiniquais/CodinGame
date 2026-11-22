#!/bin/bash

read -r n

words=()
for ((i = 0; i < n; i++)); do
    IFS= read -r word
    words+=("$word")
done

IFS= read -r letters

best_word=""
best_score=0

for word in "${words[@]}"; do
    if (( ${#word} > ${#letters} )); then
        continue
    fi

    remaining=$letters
    score=0
    valid=1

    for ((i = 0; i < ${#word}; i++)); do
        letter=${word:i:1}
        after_removal=${remaining/"$letter"/}

        if [[ "$after_removal" == "$remaining" ]]; then
            valid=0
            break
        fi

        remaining=$after_removal

        case "$letter" in
            [aeioulnrst]) ((score += 1)) ;;
            [dg])         ((score += 2)) ;;
            [bcmp])       ((score += 3)) ;;
            [fhvwy])      ((score += 4)) ;;
            k)            ((score += 5)) ;;
            [jx])         ((score += 8)) ;;
            [qz])         ((score += 10)) ;;
        esac
    done

    if (( valid && score > best_score )); then
        best_word=$word
        best_score=$score
    fi
done

echo "$best_word"