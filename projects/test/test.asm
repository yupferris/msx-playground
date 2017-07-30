; Empty ASCII mapping will give us default and suppress warnings
.asciitable
.enda

; Map each slot to the 4 swappable mem regions in the regular mem map
;  Note that here we're talking WLA slots which are like mem windows, so they map pretty 1:1
;  with 4 regions of the msx2 mem map. However this differs from what's usually referred to
;  as slots when talking about msx memory, which are more like the banks that get swapped and
;  are visible through wla slots.
.memorymap
defaultslot 2
slotsize $4000
slot 0 $0000
slot 1 $4000
slot 2 $8000
slot 3 $c000
.endme

.rombankmap
bankstotal 1
banksize $4000
banks 1
.endro

.bank 0 slot 2

header:
    .db $fe ; ID byte
    .dw start_addr
    .dw end_addr
    .dw entry

    .define CHPUT $00a2

start_addr:
entry:
    call write_msg

main_loop:
    jr main_loop

write_msg:
    ld hl, msg
write_msg_byte:
    ld a,(hl)
    or a
    ret z
    call CHPUT
    inc hl
    jr write_msg_byte

msg:
    .asc "Hello, world!"
    .db $13, $10, $00

end_addr: