
.data
vector:	.word 2,-4,-6
res:	.space 3

.text
main:	la $t0, vector	# carga la dirección del vector
	la $t1, res	# carga la dirección del resultado
	li $t5, 3		# tope de vueltas del bucle (4)
	li $t2, 1		# carga 1
	li $t4, 0 	# carga 0
	# -- if --
loop:	lw $t3, ($t0)	# carga el valor de vector[0]...
	bltz $t3, carga0	# si es < 0, 'carga0'. si es > 0, sigue la ejecución y carga 1.
	sb $t2, ($t1)	# carga 1 en res
l16:	addi $t0, $t0, 4	# suma 4 a la dirección de vector, para leer lo que sigue
	addi $t5, $t5, -1	# resta una vuelta del bucle
	addi $t1, $t1, 1	# suma 1 a la dirección de res
	bnez $t5, loop	# si el tope no llego a 0, repite ´loop´
	j end		# si el tope es 0, 'end'
	# -- else --
carga0:	sb $t4, ($t1)	# carga 0 en la dirección de memoria de res
	j l16
end:	li $v0, 10
	syscall