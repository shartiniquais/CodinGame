import System.IO
import Numeric (showIntAtBase)
import Data.Char (intToDigit)

main :: IO ()
main = do
    hSetBuffering stdout NoBuffering -- DO NOT REMOVE

    -- Auto-generated code below aims at helping you parse
    -- the standard input according to the problem statement.

    msg <- getLine
    let b = ""

    -- for each character in the message
    let bn = concatMap (\c -> 
                let ascii = fromEnum c
                    binary = showIntAtBase 2 intToDigit ascii ""
                    paddedBinary = replicate (7 - length binary) '0' ++ binary
                in paddedBinary
            ) msg
    
    let (output, _) = foldl (\(out, prev) c ->
            if c /= prev
                then if c == '1'
                    then (out ++ " 0 0", c)
                    else (out ++ " 00 0", c)
                else (out ++ "0", prev)) ("", '\0') bn

    -- Write answer to stdout
    putStrLn (dropWhile (== ' ') output)
    return()