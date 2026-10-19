.data
vector:	.word 3,7,0,2,0
res:	.space 4

.text
	la $t0, vector	# dirección de vector
	li $t1, 5		# contador de vueltas
	li $t2, 0		# sumador
	la $t4, res	# dirección de res
loop:	beqz $t1, end	# si el contador de vueltas llega a 0, salta a 'end'
	lw $t3, ($t0)	# carga en $t3, el valor de vector[0]
	beqz $t3, sumar 	# si $t3 es 0, salta a sumar
l12:	addi $t1, $t1, -1	# resta 1 vuelta al contador
	addi $t0, $t0, 4	# suma 4 a la dirección de vector, para leer el que sigue
	j loop
sumar:	addi $t2, $t2, 1	# suma 1
 	j l12
end:	sw $t2, ($t4)	# guarda en la dirección de res, el contenido del sumador
	li $v0, 10
	syscall