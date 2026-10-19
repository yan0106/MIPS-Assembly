
.data
octeto:	.byte 0x10 

# .byte reserva 1 byte (8 bits) en la sección de datos 
# y lo inicializa con el valor 0x10 (que equivale a 16 en decimal).
# La sección .data comienza en la dirección de memoria 0x10010000.
# Así que si no se especifica otra dirección, el valor 0x10 se almacena ahí.