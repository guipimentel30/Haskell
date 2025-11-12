SRC = src/KnightTour.hs
OUT = out/knighttour
INPUT = dados.txt
GHC = ghc

all: $(OUT)
$(OUT): $(SRC)
	$(GHC) -o $(OUT) $(SRC)	

run: $(OUT)
	echo $(INPUT) | ./$(OUT)	

clean:
	rm -f $(OUT) *.o *.hi	

