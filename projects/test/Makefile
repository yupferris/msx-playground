PROJECT=test
SRC=$(PROJECT).asm
OBJ=$(PROJECT).obj
BIN=$(PROJECT).bin
LINK=$(PROJECT).link

AUTOEXEC=autoexec.bas

DISKSCRIPT=disk.tcl
DISK=$(PROJECT).dsk

TESTSCRIPT=../../scripts/test.tcl

MACHINE=sony_hb-f1xd

MAKEFILE=Makefile

RM=rm
RMFLAGS=-f

all: $(DISK)

$(AUTOEXEC): $(MAKEFILE)
	# Note that this must contain only ASCII and if newlines are used, they must be \r\n
	printf "10 bload\"$(BIN)\",r" > $(AUTOEXEC)

$(OBJ): $(SRC)
	wla-z80 -o $(OBJ) $(SRC)

$(LINK): $(MAKEFILE)
	printf "[objects]\n$(OBJ)\n" > $(LINK)

$(BIN): $(OBJ) $(LINK)
	wlalink $(LINK) $(BIN)

$(DISKSCRIPT): $(MAKEFILE)
	# create disk
	printf "diskmanipulator create $(DISK) 360k\n" > $(DISKSCRIPT)

	# load disk
	printf "virtual_drive $(DISK)\n" >> $(DISKSCRIPT)

	# import file(s)
	printf "diskmanipulator import virtual_drive $(AUTOEXEC)\n" >> $(DISKSCRIPT)
	printf "diskmanipulator import virtual_drive $(BIN)\n" >> $(DISKSCRIPT)

	# byee~
	printf "exit\n" >> $(DISKSCRIPT)

$(DISK): $(AUTOEXEC) $(BIN) $(DISKSCRIPT)
	openmsx -script $(DISKSCRIPT)

test: $(DISK) $(TESTSCRIPT)
	openmsx -script $(TESTSCRIPT) -machine $(MACHINE) -diska $(DISK)

clean:
	$(RM) $(RMFLAGS) $(OBJ)
	$(RM) $(RMFLAGS) $(BIN)
	$(RM) $(RMFLAGS) $(LINK)
	$(RM) $(RMFLAGS) $(AUTOEXEC)
	$(RM) $(RMFLAGS) $(DISKSCRIPT)
	$(RM) $(RMFLAGS) $(DISK)
