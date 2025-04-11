Imports System

Module Player

    '///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    '// Function narrow_dimension:                                                                                   //
    '//   Updates the search interval in one dimension                                                               //
    '//   based on the feedback and the comparison between                                                           //
    '//   the previous position (x0 or y0) and the current position (x or y).                                        //
    '//                                                                                                              //
    '// Parameters:                                                                                                  //
    '//   $1 : previous position on the axis (x0 or y0)                                                              //
    '//   $2 : current position on the axis (x or y)                                                                 //
    '//   $3 : current lower bound (x_min or y_min)                                                                  //
    '//   $4 : current upper bound (x_max or y_max)                                                                  //
    '//   $5 : feedback ("WARMER", "COLDER", "SAME", "UNKNOWN")                                                      //
    '///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    Function NarrowDimension(prev As Integer, current As Integer, minVal As Integer, maxVal As Integer, info As String) As String
        Dim sum As Integer = prev + current
        If info = "SAME" Then
            If sum Mod 2 = 0 Then
                Dim middle As Integer = sum \ 2
                minVal = middle
                maxVal = middle
            End If
        ElseIf info = "WARMER" Then
            If current > prev Then
                Dim newLower As Integer = (sum \ 2) + 1
                If newLower > minVal Then minVal = newLower
            ElseIf current < prev Then
                Dim newUpper As Integer = If(sum Mod 2 = 0, (sum \ 2) - 1, sum \ 2)
                If newUpper < maxVal Then maxVal = newUpper
            End If
        ElseIf info = "COLDER" Then
            If current > prev Then
                Dim newUpper As Integer = If(sum Mod 2 = 0, (sum \ 2) - 1, sum \ 2)
                If newUpper < maxVal Then maxVal = newUpper
            ElseIf current < prev Then
                Dim newLower As Integer = (sum \ 2) + 1
                If newLower > minVal Then minVal = newLower
            End If
        End If
        Return $"{minVal} {maxVal}"
    End Function

    '////////////////////////////////////////////////////////////////
    '// Function narrow:                                           //
    '// Applies narrow_dimension on x as long as                   //
    '// the horizontal interval is not reduced to a single value,  //
    '// then on y if x is already determined.                      //
    '////////////////////////////////////////////////////////////////
    Function Narrow(x0 As Integer, y0 As Integer, x As Integer, y As Integer, xMin As Integer, xMax As Integer, yMin As Integer, yMax As Integer, info As String) As String
        Console.Error.WriteLine($"narrow: x0: {x0} y0: {y0} x_min: {xMin} x_max: {xMax} y_min: {yMin} y_max: {yMax} info: {info}")
        If xMin <> xMax Then
            Dim xBounds() As String = NarrowDimension(x0, x, xMin, xMax, info).Split(" "c)
            xMin = Integer.Parse(xBounds(0))
            xMax = Integer.Parse(xBounds(1))
        ElseIf yMin <> yMax Then
            Dim yBounds() As String = NarrowDimension(y0, y, yMin, yMax, info).Split(" "c)
            yMin = Integer.Parse(yBounds(0))
            yMax = Integer.Parse(yBounds(1))
        End If
        Console.Error.WriteLine($"narrow : x_min: {xMin} x_max: {xMax} y_min: {yMin} y_max: {yMax}")
        Return $"{xMin} {xMax} {yMin} {yMax}"
    End Function

    Sub Main()
        Dim inputs() As String
        inputs = Console.ReadLine().Split(" "c)
        Dim w As Integer = Integer.Parse(inputs(0)) ' width of the building
        Dim h As Integer = Integer.Parse(inputs(1)) ' height of the building
        Dim n As Integer = Integer.Parse(Console.ReadLine()) ' maximum number of turns before game over

        inputs = Console.ReadLine().Split(" "c)
        Dim x0 As Integer = Integer.Parse(inputs(0))
        Dim y0 As Integer = Integer.Parse(inputs(1))
        Dim x As Integer = x0
        Dim y As Integer = y0

        Dim xMin As Integer = 0
        Dim xMax As Integer = w - 1
        Dim yMin As Integer = 0
        Dim yMax As Integer = h - 1

        ' Main game loop
        While True
            Dim info As String = Console.ReadLine()

            Dim bounds() As String = Narrow(x0, y0, x, y, xMin, xMax, yMin, yMax, info).Split(" "c)
            xMin = Integer.Parse(bounds(0))
            xMax = Integer.Parse(bounds(1))
            yMin = Integer.Parse(bounds(2))
            yMax = Integer.Parse(bounds(3))

            Console.Error.WriteLine($"narrow results: x_min: {xMin} x_max: {xMax} y_min: {yMin} y_max: {yMax}")

            x0 = x
            y0 = y

            If xMin <> xMax Then
                If x0 = 0 AndAlso xMax + xMin + 1 <> w Then
                    x = (3 * xMin + xMax) \ 2 - x0
                ElseIf x0 = w - 1 AndAlso xMax + xMin + 1 <> w Then
                    x = (xMin + 3 * xMax) \ 2 - x0
                Else
                    x = xMax + xMin - x0
                End If
                If x = x0 Then x += 1
                If x < 0 Then x = 0
                If x > w - 1 Then x = w - 1
            Else
                If x <> xMin Then
                    x = xMin
                    x0 = x
                    Console.WriteLine($"{x} {y}")
                    info = Console.ReadLine()
                End If

                If yMin <> yMax Then
                    If y0 = 0 AndAlso yMax + yMin + 1 <> h Then
                        y = (3 * yMin + yMax) \ 2 - y0
                    ElseIf y0 = h - 1 AndAlso yMax + yMin + 1 <> h Then
                        y = (yMin + 3 * yMax) \ 2 - y0
                    Else
                        y = yMax + yMin - y0
                    End If
                    If y = y0 Then y += 1
                    If y < 0 Then y = 0
                    If y > h - 1 Then y = h - 1
                Else
                    y = yMin
                End If
            End If

            Console.WriteLine($"{x} {y}")
        End While
    End Sub

End Module
