while True:
    enemy_1: str = input()
    dist_1: int = int(input())
    enemy_2: str = input()
    dist_2: int = int(input())

    target: str = ""

    if dist_1 < dist_2:
        target = enemy_1
    else:
        target = enemy_2

    print(target)