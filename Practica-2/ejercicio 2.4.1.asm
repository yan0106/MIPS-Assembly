
.data	0x10000000
vector:	.word 10,20	# Ocupa: 0x10000000 - 0x10000007
suma: 	.space 4		# Reserva 4 bytes para la suma, empieza en 0x10000008
.text
main:	lw $s0, vector	# Carga el 1er. elemento del vector en $s0
	la $t0, vector	# Carga la dirección base del vector en $t0
	lw $s1, 4($t0)	# Carga el valor del 2.do elemento del vector en $s1
	add $t1, $s0, $s1	# Suma el contenido de el reg. $s0 y $s1, lo carga en $t1
	sw $t1, suma	# Guarda el resultado de $t1 en la dirrecc. suma (8 bytes dsps de vector)
	