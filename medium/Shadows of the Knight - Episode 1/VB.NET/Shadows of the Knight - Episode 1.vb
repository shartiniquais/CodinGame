Module Player
' Auto-generated code below aims at helping you parse
' the standard input according to the problem statement.

    Sub Main ()
        Dim inputs as String()

        Dim w as Integer ' width of the building.
        Dim h as Integer ' height of the building.
        inputs = Console.ReadLine().Split(" ")
        w = inputs(0)
        h = inputs(1)

        Dim n as Integer
        n = Console.ReadLine() ' maximum number of turns before game over.

        Dim x0 as Integer
        Dim y0 as Integer
        inputs = Console.ReadLine().Split(" ")
        x0 = inputs(0)
        y0 = inputs(1)

        Dim left as Integer
        Dim right as Integer
        Dim top as Integer
        Dim bottom as Integer
        left = 0
        right = w - 1
        top = 0
        bottom = h - 1

        ' game loop
        While True
            Dim bombDir as String
            bombDir = Console.ReadLine() ' the direction of the bombs from batman's current location (U, UR, R, DR, D, DL, L or UL)
            
            if bombDir.Contains("U") then
                bottom = y0 - 1
            elseif bombDir.Contains("D") then
                top = y0 + 1
            end if
            if bombDir.Contains("L") then
                right = x0 - 1
            elseif bombDir.Contains("R") then
                left = x0 + 1
            end if

            x0 = (left + right) / 2
            y0 = (top + bottom) / 2

            Console.WriteLine(x0 & " " & y0)
        End While
    End Sub
End Module