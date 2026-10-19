
.data
number: .word 0x12345678 # Dirección: 0x10010000
.text
main: lh $s0, number+1 # lh requiere una dirección múltiplo de 2 (osea par)

# number + 1 = 0x10010001 (no es par) ERROR

# Retorna un error "Runtime exception at" indicando la dirección del código donde
# se produce el error, en este caso, 0x400004, y luego el motivo:
# "fetch address not aligned on halfword boundary 0x10010001"
# impidiendo que el programa termine su ejecución normalmente.  