import java.util.*

fun main(args: Array<String>) {
    val inScanner = Scanner(System.`in`)

    val l = inScanner.nextInt()
    val h = inScanner.nextInt()
    inScanner.nextLine()

    val t = inScanner.nextLine().uppercase()

    val asciiArt = Array(h) { inScanner.nextLine() }

    val result = Array(h) { StringBuilder() }

    for (char in t) {
        val index = if (char in 'A'..'Z') {
            char - 'A'
        } else {
            26
        }

        for (i in 0 until h) {
            val start = index * l
            val end = start + l
            result[i].append(asciiArt[i].substring(start, end))
        }
    }

    for (i in 0 until h) {
        println(result[i])
    }
}
