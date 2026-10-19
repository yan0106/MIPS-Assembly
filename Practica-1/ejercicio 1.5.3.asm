
.data
3palabras:	.space 12		# Reserva espacio para 3 palabras (4 bytes *3)
1byte:	.byte 0x10		# Reserva un byte conteniendo 0x10
	.align 2		# Para que .word comience en una dirección múltiplo de 4 bytes
4bytes:	.word 0		# Espacio de 4 bytes
20bytes: 	.space 20 		# Reserva espacio de 20 bytes	 