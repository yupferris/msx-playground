PROJECT=test
SRC=$(PROJECT).asm
OBJ=$(PROJECT).obj
BIN=$(PROJECT).bin
LINK=$(PROJECT).link

AUTOEXEC=autoexec.bas

DISK=$(PROJECT).dsk

MACHINE=sony_hb-f1xd

RM=rm
RMFLAGS=-f

all: $(DISK)

$(AUTOEXEC):
	echo -n "10 bload\"$(BIN)\",r" > $(AUTOEXEC)

$(OBJ): $(SRC)
	wla-z80 -o $(OBJ) $(SRC)

$(BIN): test.obj test.link
	wlalink $(LINK) $(BIN)

$(DISK): $(AUTOEXEC) $(BIN) disk.tcl
	openmsx -script disk.tcl

test: $(DISK) ../../scripts/test.tcl
	openmsx -script ../../scripts/test.tcl -machine $(MACHINE) -diska $(DISK)

clean:
	$(RM) $(RMFLAGS) $(AUTOEXEC)
	$(RM) $(RMFLAGS) $(OBJ)
	$(RM) $(RMFLAGS) $(BIN)
	$(RM) $(RMFLAGS) $(DISK)
