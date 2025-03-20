import System.IO
import Control.Monad
import Data.IORef

main :: IO ()
main = do
    hSetBuffering stdout NoBuffering -- DO NOT REMOVE
    
    -- The while loop represents the game.
    -- Each iteration represents a turn of the game
    -- where you are given inputs (the heights of the mountains)
    -- and where you have to print an output (the index of the mountain to fire on)
    -- The inputs you are given are automatically updated according to your last actions.
    
    
    -- game loop
    forever $ do
        biggest <- newIORef 0
        num <- newIORef 0
        
        forM_ [0..7] $ \i -> do
            input_line <- getLine
            let mountainh = read input_line :: Int -- represents the height of one mountain.
            
            biggestVal <- readIORef biggest
            when (mountainh > biggestVal) $ do
                writeIORef biggest mountainh
                writeIORef num i
            
        
        -- hPutStrLn stderr "Debug messages..."
        
        -- The index of the mountain to fire on.
        result <- readIORef num
        print result