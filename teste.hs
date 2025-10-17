import System.Environment (getArgs)

parseLine :: String -> [Int]
parseLine line =
  map read (words line)

iteracao ::[Int] -> IO()
iteracao [rows, cols, startRow, startCol] = do
    putStrLn $ "finding solution for " ++ show rows ++ "x" ++ show cols ++ " starting  (" ++ show startRow ++ "," ++ show startCol ++ ")..."

main :: IO ()
main = do
  args <- getArgs

  case args of

    [filename] -> do
      putStrLn $ "reading " ++ filename
      
      content <- readFile filename
      let variaveisArmazenadas = map parseLine (lines content)
      putStrLn "sucess"
      mapM_ iteracao variaveisArmazenadas
      print variaveisArmazenadas

    _ -> do
      putStrLn "error"