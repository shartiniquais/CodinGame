Module Player
' CodinGame planet is being attacked by slimy insectoid aliens.
' <---
' Hint: To protect the planet, you can implement the pseudo-code provided in the statement, below the player.

    Sub Main ()
        
        ' game loop
        While True
            Dim enemy1 as String = Console.ReadLine() ' name of enemy 1
            Dim dist1 as Integer = Integer.Parse(Console.ReadLine()) ' distance to enemy 1
            Dim enemy2 as String = Console.ReadLine() ' name of enemy 2
            Dim dist2 as Integer = Integer.Parse(Console.ReadLine()) ' distance to enemy 2

            ' Write an action using Console.WriteLine()
            ' To debug: Console.Error.WriteLine("Debug messages...")

            ' Determine which enemy is closer and print its name
            Console.WriteLine(If(dist1 < dist2, enemy1, enemy2))
        End While
    End Sub
End Module