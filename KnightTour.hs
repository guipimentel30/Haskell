import System.Environment (getArgs)

data Posicao = Posicao Int Int deriving (Show)
data Dimensao = Dimensao Int Int deriving (Show)

getX :: Posicao -> Int
getX (Posicao x _) = x

getY :: Posicao -> Int
getY (Posicao _ y) = y

getW :: Dimensao -> Int
getW (Dimensao w _) = w

getH :: Dimensao -> Int
getH (Dimensao _ h) = h

posEq :: Posicao -> Posicao -> Bool
posEq (Posicao x y) (Posicao a b) =
    if x == a && y == b then True else False

pushLista :: Posicao -> [Posicao] -> [Posicao] 
pushLista pos lista = (pos : lista)

inLista :: Posicao -> [Posicao] -> Bool
inLista pos (h:t) = 
    if (posEq h pos) then True 
    else (inLista pos t)
inLista pos [] = False

movimentos :: Posicao -> [Posicao]
movimentos (Posicao x y) = [
    Posicao (x+2) (y+1),
    Posicao (x+2) (y-1),
    Posicao (x-2) (y+1),
    Posicao (x-2) (y-1),
    Posicao (x+1) (y+2),
    Posicao (x+1) (y-2),
    Posicao (x-1) (y+2),
    Posicao (x-1) (y-2)]

movimentosValidos :: [Posicao] -> Dimensao -> [Posicao]
movimentosValidos lista dim = (aplicaFiltro listaMovimentoCavalo)
    where 
        posicao_inicial = head lista
        listaMovimentoCavalo = (movimentos posicao_inicial)

        filtro :: Posicao -> Bool
        filtro pos =
            (0 < getX pos && getX pos <= getW dim) &&
            (0 < getY pos && getY pos <= getH dim) &&
            not (inLista pos lista)

        
        aplicaFiltro :: [Posicao] -> [Posicao]
        aplicaFiltro [] = []
        aplicaFiltro (h:t)
            | filtro h  = h : aplicaFiltro t
            | otherwise = aplicaFiltro t

passeio :: Posicao -> Dimensao -> [Posicao]
passeio pos dim = reverse (auxiliar [pos] dim)
    where
        testarMovimentos :: [Posicao] -> [Posicao] -> Dimensao -> [Posicao]
        testarMovimentos [] posicoes dim = []
        testarMovimentos (h:t) posicoes dim 
            | length movimentoTestado /= 0 = movimentoTestado
            | otherwise = testarMovimentos t posicoes dim
            where
                movimentoTestado = auxiliar (h:posicoes) dim 

        auxiliar :: [Posicao] -> Dimensao -> [Posicao]
        auxiliar lista dim 
            | ((getW dim) * (getH dim)) == (length lista) =
                if not (inLista (head lista) (movimentos (last lista)))                 
                then lista
                else []
            | length movs == 0 = []
            | otherwise = testarMovimentos movs lista dim
            where 
            movs = movimentosValidos lista dim

divideLinha :: String -> [Int]
divideLinha linha =
  map read (words linha)

formataPasso :: Posicao -> String
formataPasso (Posicao x y) = "(" ++ show x ++ "," ++ show y ++ ")"


formataCaminho :: [Posicao] -> String 
formataCaminho [] = ""
formataCaminho [p] = formataPasso p
formataCaminho (h:t) = formataPasso h ++ " -> "++ formataCaminho t

printResultado :: [Posicao] -> IO ()
printResultado [] =  putStrLn "Nao ha solucao valida"
printResultado caminho = do
    putStrLn $ formataCaminho caminho


iteracao ::[Int] -> IO()
iteracao [rows, cols, startRow, startCol]
    | rows <= 0 || cols <= 0 =
        putStrLn $ "Dimensao invalida na entrada (" ++ show rows ++ " " ++ show cols ++ " " ++ show startRow ++ " " ++ show startCol ++ "). As dimensoes devem ser maiores ou iguais a 1"
    | startRow <= 0 || startCol <= 0 =
        putStrLn $ "Posicao inicial invalida na entrada (" ++ show rows ++ " " ++ show cols ++ " " ++ show startRow ++ " " ++ show startCol ++ "). As colunas e linhas devem ser maiores ou iguais a 1."
    | startRow > rows || startCol > cols =
        putStrLn $ "Posicao inicial fora do tabuleiro na entrada (" ++ show rows ++ " " ++ show cols ++ " " ++ show startRow ++ " " ++ show startCol ++ ")."
    | otherwise = do
        putStrLn $ "Achando solucao para " ++ show rows ++ "x" ++ show cols ++ " iniciando em (" ++ show startRow ++ "," ++ show startCol ++ ")"
        printResultado (passeio (Posicao startRow startCol) (Dimensao rows cols))

main :: IO ()
main = do
  args <- getArgs
  filename <- case args of
    [arg] -> return arg
    _ -> do
      putStrLn "Insira seu arquivo de entrada:"
      getLine

  putStrLn $ "Lendo " ++ filename
  content <- readFile filename
  let variaveisArmazenadas = map divideLinha (lines content)
  mapM_ iteracao variaveisArmazenadas

