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
	printf "10 bload\"$(BIN)\",r" > $(AUTOEXEC)

$(OBJ): $(SRC)
	wla-z80 -o $(OBJ) $(SRC)

$(LINK):
	printf "[objects]\n$(OBJ)\n" > $(LINK)

$(BIN): $(OBJ) $(LINK)
	wlalink $(LINK) $(BIN)

$(DISK): $(AUTOEXEC) $(BIN) disk.tcl
	openmsx -script disk.tcl

test: $(DISK) ../../scripts/test.tcl
	openmsx -script ../../scripts/test.tcl -machine $(MACHINE) -diska $(DISK)

clean:
	$(RM) $(RMFLAGS) $(OBJ)
	$(RM) $(RMFLAGS) $(BIN)
	$(RM) $(RMFLAGS) $(LINK)
	$(RM) $(RMFLAGS) $(AUTOEXEC)
	$(RM) $(RMFLAGS) $(DISK)
