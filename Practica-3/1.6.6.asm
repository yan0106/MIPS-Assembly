.data
vector:	.word 6,-10,-7
res:	.space 4

.text
	la $t0, vector	# dirección de vector
	la $t1, res	# dirección de res
	li $t2, 3		# contador de vueltas para ir decrementando
	lw $t3, ($t0)	# guara el primer elemento para ir comparando
loop:	beqz $t2, end	# si el contador de vueltas llega a 0, salta a 'end'
	lw $t4, ($t0)	# carga el valor de vector[1]
	addi $t2, $t2, -1	# resta 1 vuelta al contador
	addi $t0, $t0, 4	# suma 4 a la dirección de vector para leer el que sigue	
	ble $t4, $t3, loop # si $t4 es <= $t3, salta a loop
	move $t3, $t4	# carga el mayor en $t3
	j loop
end:	sw $t3, ($t1)
	li $v0, 10
	syscall