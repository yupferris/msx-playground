set scale_algorithm simple
set scale_factor 3
set scanline 0
set blur 0

# Skip startup screens by un-throttling emulator for a short period of time
set throttle off
after time 8 {set throttle on}
