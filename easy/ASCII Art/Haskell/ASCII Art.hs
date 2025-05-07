import System.IO
import Data.Char (ord, toUpper, isUpper)
import Control.Monad (replicateM)

main :: IO ()
main = do
    hSetBuffering stdout NoBuffering -- DO NOT REMOVE

    -- Read character width and height
    l <- readLn :: IO Int
    h <- readLn :: IO Int

    -- Read input text and convert to uppercase
    t <- fmap (map toUpper) getLine

    -- Read ASCII art rows
    asciiArt <- replicateM h getLine

    -- Build result rows
    let result = [ concatMap (charSegment i l) t | i <- [0..h-1] ]
          where
            charSegment rowIdx w ch =
              let idx = if isUpper ch then ord ch - ord 'A' else 26 -- isUpper checks if the character is between 'A' and 'Z'
              in take w . drop (idx * w) $ asciiArt !! rowIdx

    -- Output each line
    mapM_ putStrLn result
