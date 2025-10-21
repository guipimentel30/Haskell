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
            (0 < getX pos && getX pos < getW dim) &&
            (0 < getY pos && getY pos < getH dim) &&
            not (inLista pos lista)

        
        aplicaFiltro :: [Posicao] -> [Posicao]
        aplicaFiltro [] = []
        aplicaFiltro (h:t)
            | filtro h  = h : aplicaFiltro t
            | otherwise = aplicaFiltro t

        
-- Dado uma posição
-- Queremos percorrer sobre todos os movimentos possíveis do cavalo
-- E eliminar as posições que: Já percorremos; Ultrapassam os limites do tabuleiro.

-- A função recebe: a lista de posições anteriores do cavalo; dimensão do tabuleiro
-- 1) Pegar posição atual do cavalo
-- 2) Pegar a possível lista de posições do cavalo
-- 3) Iterar sobre essa lista de possíveis posições do cavalo
-- 4) Aplicar um filtro: se passar no filto, continua na lista. Se não, sai da lista.


-- 0 < (getX pos) && (getX pos) < w
-- 0 < (getY pos) && (getY pos) < h
-- not (inLista pos lista)



-- passeio :: Posicao -> Dimensao -> ListaPosicao
-- passeio (Posisao pos) (Dimensao d) =

main :: IO () 
main = do
    let listaExemplo = [Posicao 1 2, Posicao 3 4, Posicao 5 6]
    print listaExemplo
    print (inLista (Posicao 1 2) listaExemplo)
    -- print (movimentosValidos (Posicao 1 1))
    print (movimentosValidos [Posicao 4 4] (Dimensao 4 8))



