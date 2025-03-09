import System.IO
import Control.Monad

main :: IO ()
main = do
    hSetBuffering stdout NoBuffering -- DO NOT REMOVE
    
    -- CodinGame planet is being attacked by slimy insectoid aliens.
    -- <---
    -- Hint: To protect the planet, you can implement the pseudo-code provided in the statement, below the player.
    
    -- game loop
    forever $ do
        enemy1 <- getLine -- name of enemy 1
        dist1 <- readLn :: IO Int -- distance to enemy 1
        enemy2 <- getLine -- name of enemy 2
        dist2 <- readLn :: IO Int -- distance to enemy 2
        
        -- hPutStrLn stderr "Debug messages..."
        
        -- Determine which enemy is closer and print its name
        putStrLn $ if dist1 < dist2 then enemy1 else enemy2