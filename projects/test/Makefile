PROJECT=test

SRC=$(PROJECT).asm

BUILD_DIR=build

OBJ=$(BUILD_DIR)/$(PROJECT).obj
BIN=$(BUILD_DIR)/MSXDOS.SYS
LINK_SCRIPT=$(BUILD_DIR)/$(PROJECT).link

MESSAGE=$(BUILD_DIR)/MESSAGE

DISK_SCRIPT=$(BUILD_DIR)/disk.tcl
DISK=$(BUILD_DIR)/$(PROJECT).dsk

TEST_SCRIPT=../../scripts/test.tcl

MACHINE=Sony_HB-F1XD

MAKEFILE=Makefile

RM=rm
RM_FLAGS=-rf

.PHONY: dirs

all: dirs $(DISK)

dirs: $(BUILD_DIR)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(OBJ): $(SRC)
	wla-z80 -o $(OBJ) $(SRC)

$(LINK_SCRIPT): $(MAKEFILE)
	printf "[objects]\n$(OBJ)\n" > $(LINK_SCRIPT)

$(BIN): $(OBJ) $(LINK_SCRIPT)
	wlalink $(LINK_SCRIPT) $(BIN)

$(MESSAGE): $(MAKEFILE)
	printf "hey it worked yey I can make this say whatever I want and it reads properly as a single record brotaku gagade$$" > $(MESSAGE)

$(DISK_SCRIPT): $(MAKEFILE)
	# create disk
	printf "diskmanipulator create $(DISK) 360k\n" > $(DISK_SCRIPT)

	# load disk
	printf "virtual_drive $(DISK)\n" >> $(DISK_SCRIPT)

	# import file(s)
	printf "diskmanipulator import virtual_drive $(BIN)\n" >> $(DISK_SCRIPT)
	printf "diskmanipulator import virtual_drive $(MESSAGE)\n" >> $(DISK_SCRIPT)

	# byee~
	printf "exit\n" >> $(DISK_SCRIPT)

$(DISK): $(BIN) $(MESSAGE) $(DISK_SCRIPT)
	openmsx -script $(DISK_SCRIPT)

test: dirs $(DISK) $(TEST_SCRIPT)
	openmsx -script $(TEST_SCRIPT) -machine $(MACHINE) -diska $(DISK)

clean:
	$(RM) $(RM_FLAGS) $(BUILD_DIR)
