Module Solution
' Auto-generated code below aims at helping you parse
' the standard input according to the problem statement.

    Sub Main ()
        
        Dim n as Integer
        n = Console.ReadLine() ' the number of temperatures to analyse

        if n = 0 then
            Console.WriteLine("0")
            return
        End If

        Dim min_value as Integer = 5526
        Dim min_abs as Integer = 5526

        Dim inputs as String()
        inputs = Console.ReadLine().Split(" ")
        For i as Integer = 0 To n-1
            Dim t as Integer ' a temperature expressed as an integer ranging from -273 to 5526
            t = inputs(i)

            if Math.Abs(t) < min_abs then
                min_abs = Math.Abs(t)
                min_value = t
            else if Math.Abs(t) = min_abs then
                if t > 0 then
                    min_value = t
                End If
            End If
        Next

        ' Write an answer using Console.WriteLine()
        ' To debug: Console.Error.WriteLine("Debug messages...")

        Console.WriteLine(min_value)
    End Sub
End Module