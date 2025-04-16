import System.IO
import Control.Monad
import Control.Monad.RWS.Lazy (MonadState(put))
import Data.List (isInfixOf)

main :: IO ()
main = do
    hSetBuffering stdout NoBuffering -- DO NOT REMOVE
    
    -- Auto-generated code below aims at helping you parse
    -- the standard input according to the problem statement.
    
    input_line <- getLine
    let input = words input_line
    let w = read (input!!0) :: Int -- width of the building.
    let h = read (input!!1) :: Int -- height of the building.
    input_line <- getLine
    let _ = read input_line :: Int -- maximum number of turns before game over. (not used)
    input_line <- getLine
    let input = words input_line
    let x0 = read (input!!0) :: Int
    let y0 = read (input!!1) :: Int
    
    let left = 0
    let right = w - 1
    let top = 0
    let bottom = h - 1

    -- game loop
    let loop left right top bottom x0 y0 = do
            input_line <- getLine
            let bombdir = input_line :: String

            let bottom' = if "U" `isInfixOf` bombdir then y0 - 1 else bottom
            let top' = if "D" `isInfixOf` bombdir then y0 + 1 else top
            let right' = if "L" `isInfixOf` bombdir then x0 - 1 else right
            let left' = if "R" `isInfixOf` bombdir then x0 + 1 else left

            let x0' = (left' + right') `div` 2
            let y0' = (top' + bottom') `div` 2

            putStrLn $ show x0' ++ " " ++ show y0'
            loop left' right' top' bottom' x0' y0'

    loop left right top bottom x0 y0




