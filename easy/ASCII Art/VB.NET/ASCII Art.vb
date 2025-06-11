Module Solution
    Sub Main()
        Dim l As Integer = Convert.ToInt32(Console.ReadLine())
        Dim h As Integer = Convert.ToInt32(Console.ReadLine())

        Dim t As String = Console.ReadLine().ToUpper()

        Dim asciiArt(h - 1) As String
        For i As Integer = 0 To h - 1
            asciiArt(i) = Console.ReadLine()
        Next

        Dim result(h - 1) As System.Text.StringBuilder
        For i As Integer = 0 To h - 1
            result(i) = New System.Text.StringBuilder()
        Next

        For Each c As Char In t
            Dim index As Integer
            If c >= "A"c AndAlso c <= "Z"c Then
                index = Asc(c) - Asc("A"c)
            Else
                index = 26
            End If

            For i As Integer = 0 To h - 1
                Dim segment As String = asciiArt(i).Substring(index * l, l)
                result(i).Append(segment)
            Next
        Next

        For Each line As System.Text.StringBuilder In result
            Console.WriteLine(line.ToString())
        Next
    End Sub
End Module
