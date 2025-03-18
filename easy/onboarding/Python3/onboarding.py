# game loop
while True:
    enemy_1 = input()  # name of enemy 1
    dist_1 = int(input())  # distance to enemy 1
    enemy_2 = input()  # name of enemy 2
    dist_2 = int(input())  # distance to enemy 2

    # Determine which enemy is closer and print its name
    print(enemy_1 if dist_1 < dist_2 else enemy_2)