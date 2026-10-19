
.data
number:	.word 0x10203040	# Comienza en dirección 0x10010000 hasta 0x10010003
place:	.space 4		# reserva 4 bytes, de 0x100100004 hasta 0x10010007
other:	.word 0xffffffff	# de 0x10010008 a 0x1001000B

.text
main:	lw $s0, number	# Carga 0x10203040 en $s0
	sw $s0, place	# Guarda 0x10203040 en la dirección de 'place' (0x10010004)
	sw $s0, other	# Guarda 0x10203040 en la dirección de 'other' (0x10010008)
	
	