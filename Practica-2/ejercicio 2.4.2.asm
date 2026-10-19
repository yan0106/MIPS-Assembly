
.data	0x10000000
vector:	.word 18,-1215
divisor: 	.word 5
.data	0x10010000 	# Especifica la dirección para los resultados
cociente:	.space 8		# Reserva espacio para dos palabras de 4 bytes c/u

.text
main:	la $t0, vector	# Carga la dirección del vector
	lw $s0, divisor	# Carga el valor de divisor(5) en $s0
	lw $s1, vector	# Carga el 1er. elemento del vector (18) en $s1
	lw $s2, 4($t0)	# Carga el 2do. elemento del vector (-1215) en $s2
	
	div $s1, $s0	# Divide $s1(18) con $s0(5). Cociente -> lo, Resto -> hi
	mflo $t1
	
	div $s2, $s0	# Divide $s2(-1215) con $s0(5).  Cociente -> lo, Resto -> hi
	mflo $t2
	
	la $t3, cociente	# Carga la dirección de cociente en $t3
	sw $t1, 0($t3)	# Guarda el contenido de $t1 en la direcc. de cociente (0x10010000)
	sw $t2, 4($t3)    # Guarda el contenido de $t2 en la direcc. cociente+4 (0x10010004)
	 