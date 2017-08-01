; Empty ASCII mapping will give us default and suppress warnings
.asciitable
.enda

; Map each slot to the 4 mem pages in the msx2 mem map
;  Note that here we're talking wla slots which are like mem windows, so they map pretty 1:1
;  with 4 pages of the msx2 mem map. However this differs from what's usually referred to
;  as slots when talking about msx memory, which are distinct groups of pages, much like
;  groups of wla banks that get swapped, and portions of which are visible through wla slots.
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

write_msg:
    ld hl, msg
write_msg_byte:
    ld a, (hl)
    or a
    ret z
    call CHPUT
    inc hl
    jr write_msg_byte

msg:
    .asc "Hello, world!"
    .db $13, $10, $00

    ; TODO: Proper RAM section for this? This should technically work just fine, but I'm not
    ;  sure how well WLA handles mixed RAM/ROM or if there's a nicer way to do this.
color_value:
    .db $00

end_addr:
