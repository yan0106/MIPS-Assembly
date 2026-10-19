.data
lista:	.word 3,7,4,2,5
res:	.space 1

.text
	la $t0, lista		# dirección de lista
	li $t1, 2			# contador de vueltas (2)
	lw $t4, 16($t0)		# carga el 5° valor
	la $t6, res		# dirección de res
loop:	beqz $t1, end		# si el contador de vuelta llega a 0, salta a 'end'
	lw $t2, ($t0)		# carga el valor de lista[0], lista[2]
	lw $t3, 4($t0)		# carga el valor de lista[1], lista[3]
	bgt $t2, $t3, esmayor	# si $t2 (3) > $t3 (7)?, salta a 'esmayor'
# -- (data5 > data1 && data5 < data2) -- #
	slt $t7, $t4, $t3		# si $t4 (5) < $t3 (7)? = 1
	sgt $t8, $t4, $t2		# si $t4 (5) > $t2 (3)? = 1
	and $t9, $t7, $t8		# si $t7 es 1 and $t8 es 1 = 1
	beqz $t9, l15
result:	sb $t9, ($t6)		# guarda el resultado en la dir de res
	j end
l15:	addi $t1, $t1, -1		# resta 1 vuelta al contador
	addi $t0, $t0, 8		# suma 8 para leer el que sigue, lista[2]	
	j loop	
esmayor:	slt $t7, $t4, $t2		# si $t4 (5) < $t2 (4)? = 0
	sgt $t8, $t4, $t3		# si $t4 (5) > $t3 (1)? = 1
	and $t9, $t7, $t8		# si $t7 es 0 and $t8 es 1 = 0
	beqz $t9, l15
	j result			# salta a result, si es exitoso
end: 	li $v0, 10
	syscall