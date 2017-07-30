PROJECT=test

DISK=$(PROJECT).dsk

MACHINE=sony_hb-f1xd

RM=rm
RMFLAGS=-f

all: $(DISK)

$(DISK): autoexec.bas disk.tcl
	openmsx -script disk.tcl

test: $(DISK) ../scripts/test.tcl
	openmsx -script ../scripts/test.tcl -machine $(MACHINE) -diska $(DISK)

clean:
	$(RM) $(RMFLAGS) $(DISK)
