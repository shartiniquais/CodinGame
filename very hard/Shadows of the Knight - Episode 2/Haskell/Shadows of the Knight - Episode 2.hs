import System.IO
import Control.Monad
import Data.List.Split (splitOn)
import Data.Maybe (fromMaybe)

-- Function narrowDimension:
--   Updates the search interval in one dimension
--   based on the feedback and the comparison between
--   the previous position (x0 or y0) and the current position (x or y).
--
-- For SAME, if (x0+x) (or y0+y) is even, the bomb is
-- exactly in the middle.
--
-- For WARMER/COLDER, we deduce which side of the interval to keep:
--   - If x > x0 and WARMER, the bomb is to the right of the middle,
--     so new_min = ((x0+x)/2) + 1.
--   - If x > x0 and COLDER, the bomb is to the left, so new_max = (x0+x)/2 - (if even) or = (x0+x)/2 (if odd).
--
-- The same reasoning applies for y.

narrowDimension :: Int -> Int -> Int -> Int -> String -> (Int, Int)
narrowDimension prev current minV maxV info
    | info == "SAME" =
        let sum' = prev + current
        in if even sum'
            then let middle = sum' `div` 2 in (middle, middle)
            else (minV, maxV)
    | info == "WARMER" =
        if current > prev
            then let sum' = prev + current
                     new_lower = sum' `div` 2 + 1
                 in (max minV new_lower, maxV)
            else if current < prev
                then let sum' = prev + current
                         new_upper = if even sum' then sum' `div` 2 - 1 else sum' `div` 2
                     in (minV, min maxV new_upper)
                else (minV, maxV)
    | info == "COLDER" =
        if current > prev
            then let sum' = prev + current
                     new_upper = if even sum' then sum' `div` 2 - 1 else sum' `div` 2
                 in (minV, min maxV new_upper)
            else if current < prev
                then let sum' = prev + current
                         new_lower = sum' `div` 2 + 1
                     in (max minV new_lower, maxV)
                else (minV, maxV)
    | otherwise = (minV, maxV)

-- Function narrow:
-- Applies narrowDimension on x as long as
-- the horizontal interval is not reduced to a single value,
-- then on y if x is already determined.

narrow :: Int -> Int -> Int -> Int -> Int -> Int -> Int -> Int -> String -> (Int, Int, Int, Int)
narrow x0 y0 x y x_min x_max y_min y_max info
    | x_min /= x_max =
        let (new_x_min, new_x_max) = narrowDimension x0 x x_min x_max info
        in (new_x_min, y_min, new_x_max, y_max)
    | y_min /= y_max =
        let (new_y_min, new_y_max) = narrowDimension y0 y y_min y_max info
        in (x_min, new_y_min, x_max, new_y_max)
    | otherwise = (x_min, y_min, x_max, y_max)

main :: IO ()
main = do
    hSetBuffering stdout NoBuffering -- DO NOT REMOVE
    [w, h] <- fmap (map read . words) getLine
    _ <- getLine -- max number of turns, unused
    [x0_init, y0_init] <- fmap (map read . words) getLine
    let x_min0 = 0
        x_max0 = w - 1
        y_min0 = 0
        y_max0 = h - 1
    gameLoop x0_init y0_init x0_init y0_init x_min0 x_max0 y_min0 y_max0 w h

gameLoop :: Int -> Int -> Int -> Int -> Int -> Int -> Int -> Int -> Int -> Int -> IO ()
gameLoop x0 y0 x y x_min x_max y_min y_max w h = do
    info <- getLine
    let (x_min', y_min', x_max', y_max') = narrow x0 y0 x y x_min x_max y_min y_max info

    let (x0', y0') = (x, y)
    (x', y') <- if x_min' /= x_max'
        then do
            let x1
                  | x0' == 0 && x_max' + x_min' + 1 /= w = (3 * x_min' + x_max') `div` 2 - x0'
                  | x0' == w - 1 && x_max' + x_min' + 1 /= w = (x_min' + 3 * x_max') `div` 2 - x0'
                  | otherwise = x_min' + x_max' - x0'
                x2 = if x1 == x0' then x0' + 1 else x1
                xFinal = max 0 (min (w - 1) x2)
            return (xFinal, y)
        else do
            let x1 = if x /= x_min' then x_min' else x
            yInput <- if x /= x_min'
                then do
                    putStrLn (show x1 ++ " " ++ show y)
                    getLine
                else return info
            let y0'' = y
            let y1 = if y_min' /= y_max'
                        then if y0'' == 0 && y_max' + y_min' + 1 /= h
                                then (3 * y_min' + y_max') `div` 2 - y0''
                             else if y0'' == h - 1 && y_max' + y_min' + 1 /= h
                                then (y_min' + 3 * y_max') `div` 2 - y0''
                             else y_max' + y_min' - y0''
                        else y_min'
                y2 = if y1 == y0'' then y0'' + 1 else y1
                yFinal = max 0 (min (h - 1) y2)
            return (x1, yFinal)

    putStrLn (show x' ++ " " ++ show y')
    gameLoop x0' y0' x' y' x_min' x_max' y_min' y_max' w h
