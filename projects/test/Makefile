PROJECT=test

SRC=$(PROJECT).asm

BUILDDIR=build

OBJ=$(BUILDDIR)/$(PROJECT).obj
BIN=$(BUILDDIR)/$(PROJECT).bin
LINKSCRIPT=$(BUILDDIR)/$(PROJECT).link

AUTOEXEC=$(BUILDDIR)/autoexec.bas

DISKSCRIPT=$(BUILDDIR)/disk.tcl
DISK=$(BUILDDIR)/$(PROJECT).dsk

TESTSCRIPT=../../scripts/test.tcl

MACHINE=sony_hb-f1xd

MAKEFILE=Makefile

RM=rm
RMFLAGS=-rf

.PHONY: dirs

all: dirs $(DISK)

dirs: $(BUILDDIR)

$(BUILDDIR):
	mkdir -p $(BUILDDIR)

$(AUTOEXEC): $(MAKEFILE)
	# Note that this must contain only ASCII and if newlines are used, they must be \r\n
	printf "10 bload\"$(BIN)\",r" > $(AUTOEXEC)

$(OBJ): $(SRC)
	wla-z80 -o $(OBJ) $(SRC)

$(LINKSCRIPT): $(MAKEFILE)
	printf "[objects]\n$(OBJ)\n" > $(LINKSCRIPT)

$(BIN): $(OBJ) $(LINKSCRIPT)
	wlalink $(LINKSCRIPT) $(BIN)

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

test: dirs $(DISK) $(TESTSCRIPT)
	openmsx -script $(TESTSCRIPT) -machine $(MACHINE) -diska $(DISK)

clean:
	$(RM) $(RMFLAGS) $(BUILDDIR)
