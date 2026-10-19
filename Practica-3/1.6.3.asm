
.data
vector:	.word -1,-4,-5,-3
res:	.space 1

.text
	la $t0, vector	# dirección del vector
	li $t1, 4		# contador de vueltas
	li $t4, 0		# resultado (0) si al menos 1 es mayor que 0
	li $t5, 1		# resultado (1) si todos son menores que 0
	la $t6, res       	# dirección de res 
loop:	beqz $t1,	fin_loop	# si el contador de vueltas es 0, salta a 'fin_loop'
	lw $t3, ($t0)	# carga el contenido de vector[0]	
	bltz $t3, menor0	# si es < 0, salta a 'menor0'
	j mayor0
menor0:	addi $t1, $t1, -1	# resta 1 vuelta al contador de vueltas
	addi $t0, $t0, 4	# avanza la dirección de memoria (4), para leer el que sigue
	j loop
mayor0:	sb $t4, ($t6)	# cdo tengo al menos uno > 0, ya guarda el resultado (0)
	j end
fin_loop:	sb $t5, ($t6)	# si el contador de vueltas es 0, significa que todos son < 0, guarda el resultado (1)
end:	li $v0, 10
	syscall	
	
		