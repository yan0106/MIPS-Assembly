
.data
byte1: .byte 0x10 # 1 byte (0x10010000)
espacio: .space 4 # 4 bytes (0x10010001-0x10010004)
byte2: .byte 0x20 # 1 byte (0x10010005) --> aparece en 0x10010004?
entero: .word 10 # 4 bytes (0x10010006-0x10010009) --> aparece en 0x10010008?

