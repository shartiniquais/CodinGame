Module Solution
    ' Auto-generated code below aims at helping you parse
    ' the standard input according to the problem statement.

    Sub Main()
        Dim MSG As String = Console.ReadLine()
        Dim output As String = ""
        Dim bn As String = ""
        Dim b As Char = Chr(0) ' Initialize the variable to store the last bit

        ' Convert each character in the message to its binary representation
        For Each c As Char In MSG
            Dim ascii As Integer = Asc(c) ' Convert the character to ASCII
            Dim binary_value As String = Convert.ToString(ascii, 2) ' Convert the ASCII to binary
            Dim binary As String = binary_value.PadLeft(7, "0"c) ' Pad the binary value to 7 bits
            bn &= binary ' Append the binary value to the binary string
        Next

        ' Convert the binary string to unary
        For Each c As Char In bn
            If c <> b Then
                If c = "1"c Then
                    output &= " 0 "
                ElseIf c = "0"c Then
                    output &= " 00 "
                End If
                b = c ' Update the previous bit
            End If
            output &= "0" ' Add a unary '0' for each bit
        Next

        ' Trim leading and trailing spaces and print the result
        Console.WriteLine(output.Trim())
    End Sub
End Module