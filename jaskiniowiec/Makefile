PYTHON ?= py -3

all:	bin/game.obx

bin/game.obx:	main.asm $(wildcard src/*)
	mads main.asm -o:bin/game.obx

test:	bin/game.obx
	$(PYTHON) verify.py bin/game.obx

clean:
	rm -f bin/game.obx
