# Modifica el código anterior para que los parámetros de entrada a la subrutina
# se pasen por valor mediante la pila y el de salida se pase también a
# través de la pila pero por referencia.

.data
rango1:	.word 10
rango2:	.word 50
dato:	.word 12
res:	.space 1

.text
main:	addi $sp, $sp, -20	# reserva 20 bytes en la pila (4 params + $ra)
	sw $ra, 16($sp)		# apilar $ra en el fondo del marco de main
	
	lw $t0, rango1($0)	# cargar valor de rango1
	sw $t0, 0($sp)		# apilar rango1 en 0($sp) (tope)
	
	lw $t0, rango2($0)	# cargar valor de rango2
	sw $t0, 4($sp)		# apilar rango2 en 4($sp)
	
	lw $t0, dato($0)	# cargar valor de dato
	sw $t0, 8($sp)		# apilar dato en 8($sp)
	
	la $t0, res($0)		# cargar DIRECCIÓN de res (por referencia)
	sw $t0, 12($sp)		# apilar dirección de res en 12($sp)
	
	jal subr		# saltar a subr
	
	lw $ra, 16($sp)		# desapilar $ra
	addi $sp, $sp, 20	# liberar los 20 bytes de la pila
	li $v0, 10		# terminar la ejecución del programa
	syscall	
	
subr:	lw $t0, 0($sp)		# lee el valor de rango1
	lw $t1, 4($sp)		# lee el valor de rango2
	lw $t2, 8($sp)		# lee el valor de dato
	lw $t4, 12($sp)		# lee la dirección de res
	
	blt $t2, $t0, sino	# si t2 < t0 saltar a sino
	bgt $t2, $t1, sino	# si t2 > t1 saltar a sino

entonces:
	addi $t3, $0, 1		# t3 = 1
	j finsi			# saltar a finsi

sino:	add $t3, $0, $0		# t3 = 0

finsi:	sb $t3, 0($t4)		# guarda el resultado en la dirección de res
	jr $ra	