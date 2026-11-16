# Modifica el código anterior para que los parámetros que se pasan a la subrutina subr,
# tanto los de entrada como el de salida, se pasen por referencia.

.data
rango1:	.word 10
rango2:	.word 50
dato:	.word 12
res:	.space 1

.text
main:	addi $sp, $sp, -4
	sw $ra, 0($sp)		# apilar ra
	la $a0, rango1($0)	# a0 = dir de rango1
	la $a1, rango2($0)	# a1 = dir de rango2
	la $a2, dato($0)	# a2 = dir de dato
	la $a3, res($0)		# a3 = dir de res
	jal subr		# saltar a subr
	lw $ra, 0($sp)
	addi $sp, $sp, 4	# desapilar ra
	li $v0, 10		# terminar la ejecución del programa
	syscall			
	
subr:	lw $t0, 0($a0)		# leer el contenido de rango1
	lw $t1, 0($a1)		# leer el contenido de rango2
	lw $t2, 0($a2)		# leer el contenido de dato
	blt $t2, $t0, sino	# si t2 < t0 saltar a sino
	bgt $t2, $t1, sino	# si t2 > t1 saltar a sino

entonces:	
	addi $t3, $0, 1		# t3 = 1
	j finsi			# saltar a finsi

sino:	add $t3, $0, $0		# t3 = 0

finsi:	sb $t3, 0($a3)		# guardar resultado en la dirección apuntada por $a3 (res)
	jr $ra	 

