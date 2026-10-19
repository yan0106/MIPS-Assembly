
.data
number:	.word 0xffffff41
	.space 4

.text
	lw $s0, number	# Carga el valor de number en el registro $s0
	sra $s1, $s0, 4	# Desplaza el valor de number 4 bits a la derecha. Rellena el hueco
			# generado a la izq. con el bit de signo (1) y lo guarda en $s1
	sw $s1, number+4	# Guarda el valor del registro $s1 en la posición de memoria number+4