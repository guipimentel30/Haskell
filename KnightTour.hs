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
        -- testarMovimentos movimentos posicoes dim

        auxiliar :: [Posicao] -> Dimensao -> [Posicao]
        auxiliar lista dim 
            | ((getW dim) * (getH dim)) == (length lista) = lista
            | length movimentos == 0 = []
            | otherwise = testarMovimentos movimentos lista dim
            where 
                movimentos = movimentosValidos lista dim

parseLine :: String -> [Int]
parseLine line =
  map read (words line)

iteracao ::[Int] -> IO()
iteracao [rows, cols, startRow, startCol] = do
    putStrLn $ "Achando solucao para " ++ show rows ++ "x" ++ show cols ++ " iniciando (" ++ show startRow ++ "," ++ show startCol ++ ")..."
    printLn (passeio (Posicao startRow startCol) (Dimensao rows cols))

main :: IO ()
main = do
    let filename = "dados.txt"
    content <- readFile filename
    let variaveisArmazenadas = map parseLine (lines content)
    mapM_ iteracao variaveisArmazenadas
    print variaveisArmazenadas
