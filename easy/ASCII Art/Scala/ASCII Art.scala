import scala.io.StdIn._

object Solution extends App {
    val l = readLine.toInt
    val h = readLine.toInt
    val t = readLine.toUpperCase

    val asciiArt = Array.ofDim[String](h)
    for (i <- 0 until h) {
        asciiArt(i) = readLine
    }

    val result = Array.fill(h)(new StringBuilder)

    for (c <- t) {
        val index = if (c >= 'A' && c <= 'Z') {
            c - 'A'
        } else {
            26
        }

        for (i <- 0 until h) {
            result(i).append(asciiArt(i).slice(index * l, (index + 1) * l))
        }
    }

    result.foreach(println)
}
