; Empty ASCII mapping will give us default 1:1 mapping and suppress warnings
.asciitable
.enda

; Just treat mem as one big contiguous area starting at $100
;  Basically max TOTAL_SIZE is going to be ~64kb minus $100 (eg. $fe00), but wla is going to output
;  the entire bank even if we don't fill it, so it's best to keep TOTAL_SIZE small and increase it
;  as needed to reduce load time for bytes we don't use.

.define TOTAL_SIZE $0200

.memorymap
defaultslot 0
slotsize TOTAL_SIZE
slot 0 $0100
.endme

.rombankmap
bankstotal 1
banksize TOTAL_SIZE
banks 1
.endro

; BDOS

.define BDOS $f37d
.define CONOUT $02
.define STROUT $09
.define FOPEN $0f
.define FCLOSE $10
.define SETDTA $1a
.define RDBLK $27

.define FCB $005c

entry:
    ; Load message from file
    ;  Prepare unopened FCB
    ld hl, FCB
    ;   Drive number (0 = default)
    ld a, 0
    ld (hl), a
    inc hl
    ;   File name
    ld de, message_file_name
    ld b, 11
load_message_file_name_loop:
        ld a, (de)
        ld (hl), a
        inc de
        inc hl
    djnz load_message_file_name_loop

    ;  Open file
    ld de, FCB
    ld c, FOPEN
    call BDOS

    ;  Set DTA addr
    ;   We'll use a random block read to read the whole file as one block, so we can just set this to our target addr
    ld de, message
    ld c, SETDTA
    call BDOS

    ;  Set record size to file size
    ;   Since we can safely assume the file is less than 64kb bytes in size, we can just copy out the low two bytes of the file size
    ld hl, (FCB + 16)
    ld (FCB + 14), hl

    ;  Clear random record
    ld hl, 0
    ld (FCB + 33), hl
    ld (FCB + 35), hl

    ;  Read record
    ;   Here we read the entire message as one record
    ld de, FCB
    ld hl, 1
    ld c, RDBLK
    call BDOS

    ;  Close file
    ld de, FCB
    ld c, FCLOSE
    call BDOS

    ; Write out message
    ld de, message
    ld c, STROUT
    call BDOS

    ; Disable interrupts (otherwise our VDP I/O could get screwed due to internal index flip flops)
    di

    ; Set bg/fg colors to color 0
    ld a, 0
    out ($99), a
    ld a, $07 | $80
    out ($99), a

main_loop:
    ; Set color number to zero (we'll overwrite this color)
    ld a, 0
    out ($99), a
    ld a, $10 | $80
    out ($99), a

    ; Output next color and increment color value
    ld hl, color_value
    ld a, (hl)
    out ($9a), a
    out ($9a), a
    inc (hl)

    jr main_loop

message_file_name:
    ;     ***********
    .asc "MESSAGE    "

color_value:
    .db $00

message: ; Will be read from file
