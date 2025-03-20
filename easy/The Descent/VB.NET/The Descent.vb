Module Player
' The while loop represents the game.
' Each iteration represents a turn of the game
' where you are given inputs (the heights of the mountains)
' and where you have to print an output (the index of the mountain to fire on)
' The inputs you are given are automatically updated according to your last actions.

    Sub Main ()
        
        ' game loop
        While True
            Dim biggest As Integer = 0
            Dim num As Integer = 0

            For i as Integer = 0 To 7
                Dim mountainH as Integer
                mountainH = Console.ReadLine() ' represents the height of one mountain.

                If biggest < mountainH Then
                    biggest = mountainH
                    num = i
                End If
            Next

            ' Write an action using Console.WriteLine()
            ' To debug: Console.Error.WriteLine("Debug messages...")

            Console.WriteLine(num) ' The index of the mountain to fire on.
        End While
    End Sub
End Module