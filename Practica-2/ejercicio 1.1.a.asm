
.data # directiva

.text	# zona de instrucciones
main: lui $s0, 0x8690	# dirección: 0x00400000

# etiqueta main: , le indica al simulador donde es el principio del programa.
# la instrucción lui, carga la constante en la parte alta del registro $s0. La parte baja
# del registro, correspondiente a los bits de menor peso, se completa con ceros.

# Tamaño: Ocupa las direcciones 0x00400000, 0x00400001, 0x00400002 y 0x00400003.
# La siguiente instrucción comenzaría en 0x00400004.

