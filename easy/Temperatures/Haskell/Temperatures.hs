import System.IO
import Data.List
import Data.Ord

main :: IO ()
main = do
    hSetBuffering stdout NoBuffering -- DO NOT REMOVE
    
    -- Read the number of temperatures to analyze
    n <- readLn :: IO Int

    if n /= 0 then do
        -- Read the temperatures into a list
        input <- getLine
        let values = map (read :: String -> Int) (words input)

        -- Find the closest temperature to zero
        let result = findClosestToZero values

        -- Print the result
        print result
    else
        -- Print 0 if there are no temperatures
        print 0

-- Function to find the closest temperature to zero
findClosestToZero :: [Int] -> Int
findClosestToZero values =
    minimumBy (comparing (\x -> (abs x, -x))) values