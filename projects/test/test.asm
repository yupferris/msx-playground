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

entry:
    ; Write out messages (syscall test)
    ld de, message1
    ld c, STROUT
    call BDOS

    ld hl, message2
message_2_char_loop:
        ld a, (hl)
        or a
        jr z, message_2_char_loop_end

        push hl
        push af

        ld e, a
        ld c, CONOUT
        call BDOS

        pop af
        pop hl

        inc hl
    jr message_2_char_loop
message_2_char_loop_end:

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

message1:
    .asc "hi gotaku birade ruls mmk"
    .db $13, $10
    .asc "$"
message2:
    .asc "hi its me again fam"
    .db $00

color_value:
    .db $00
