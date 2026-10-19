
.data
palabra1: .word 0x20 # ocupa 4 bytes (0x10010000–0x10010003)
espacio: .space 8 # reserva 8 bytes (0x10010004–0x1001000B)
palabra2: .word 0x30 # ocupa 4 bytes (0x1001000C–0x1001000F)

# Data empieza en 0x10010000