# Realiza las siguientes implementaciones:
# c) Implementa la subrutina donde los parámetros que se pasan sean
# del mismo tipo que en el caso a) pero utilizando la pila como lugar para
# realizar el paso de parámetros.

.data
vector: .word 3,4,9,12,4
dato: 	.word 4
cant:	.space 4

.text
main:	addi $sp, $sp, -12	# reservo memoria para 3 argumentos
	# $t0 como registro puente: los datos viajan por la pila
	la $t0, vector		# dirección del vector por referencia
	sw $t0, 0($sp)
	li $t0, 5		# total de elementos del vector, por valor
	sw $t0, 4($sp)
	lw $t0, dato		# dato, por valor
	sw $t0, 8($sp)
	
	jal contador		# salta a la subrutina contador
	sw $v0, cant
	
fin:	addi $sp, $sp, 12	# devuelvo la memoria de la pila
	li $v0, 10
	syscall

# contador es una subrutina hoja (no llama a otra subrutina), no necesita tocar la pila ni $ra.
contador:
	# leer la pila:
	lw $t1, 0($sp)		# carga en $t1 = puntero a vector
	lw $t2, 4($sp)		# carga en $t2 = total de elem del vector
	lw $t3, 8($sp)		# carga en $t3 = dato
	li $t0, 0		# contador = 0
	
loop:	beqz $t2, fin_loop	# si el total de elem es 0, ya recorrió todo	
	lw $t4, 0($t1)		# lee el primer elem	
	addi $t1, $t1, 4	# avanza el puntero
	addi $t2, $t2, -1	# resta 1 del total
	bne $t4, $t3, loop	# si $t4 != dato, salta a loop sin sumar el contador
	addi $t0, $t0, 1	# le suma 1 al contador
	j loop
	
fin_loop:
	move $v0, $t0		# guarda el contenido del contador $t0 en $v0
	jr $ra
