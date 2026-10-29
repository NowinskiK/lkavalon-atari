PYTHON ?= py -3

all:	bin/game.obx

bin/game.obx:	main.asm src/JOINT.ASM src/TRAINER.ASM src/CODE7C.ASM src/MAIN.ASM src/CODEA0.ASM src/START.ASM src/CMC.ASM src/VECTORS.ASM src/SYSTEM.DTA src/D0500.DTA src/D1800.DTA src/D2500.DTA src/LEVELS.DTA src/D6470.DTA src/FONT6C.FNT src/D7000.DTA src/TABLES.DTA src/MUSIC.CMC
	mads main.asm -o:bin/game.obx

test:	bin/game.obx
	$(PYTHON) verify.py bin/game.obx

clean:
	rm -f bin/game.obx
