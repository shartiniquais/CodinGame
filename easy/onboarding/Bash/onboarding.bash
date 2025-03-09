# CodinGame planet is being attacked by slimy insectoid aliens.
# <---
# Hint: To protect the planet, you can implement the pseudo-code provided in the statement, below the player.

# game loop
while true; do
    # Read the name and distance of enemy 1
    read -r enemy1
    read -r dist1

    # Read the name and distance of enemy 2
    read -r enemy2
    read -r dist2

    # Determine which enemy is closer and print its name
    if [ "$dist1" -lt "$dist2" ]; then
        echo "$enemy1"
    else
        echo "$enemy2"
    fi
done