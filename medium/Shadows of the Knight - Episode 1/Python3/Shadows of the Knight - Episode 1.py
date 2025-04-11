w, h = [int(i) for i in input().split()]
_ = int(input())
x0, y0 = [int(i) for i in input().split()]

# Définition des bornes
left = 0
right = w - 1
top = 0
bottom = h - 1

while True:
    bomb_dir = input()

    if 'U' in bomb_dir:
        bottom = y0 - 1
    elif 'D' in bomb_dir:
        top = y0 + 1

    if 'L' in bomb_dir:
        right = x0 - 1
    elif 'R' in bomb_dir:
        left = x0 + 1

    # Calcul de la nouvelle position
    x0 = (left + right) // 2
    y0 = (top + bottom) // 2

    print(x0, y0)