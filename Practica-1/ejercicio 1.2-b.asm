
.data
palabra1: .byte 0x10, 0x20, 0x30, 0x40 # .byte reserva 1 byte por valor (total: 4 bytes consecutivos)
palabra2: .word 0x10203040 # .word reserva 4 bytes para un solo valor

# Conclusión:
# En palabra1, los valores aparecen en el orden que se escribieron
# En palabra2, el mismo patrón de bytes está invertido porque MIPS guarda el valor
# en formato little endian : guarda primero el byte menos significativo.