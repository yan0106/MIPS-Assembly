# Realiza las siguientes implementaciones:
# b) Implementa la subrutina de forma que todos los parámetros se
# pasen por referencia y a través de registros.

.data
vector: .word 3,4,9,12,4
dato: 	.word 4
elem:	.word 5
cant:	.space 4

.text
main:
	la $a0, vector		# a0 = dirección del vector por referencia
	la $a1, elem		# a1 = direción del total de elementos del vector, por referencia
	la $a2, dato		# a2 = dirección de dato, por referencia
	la $a3, cant		# a3 = dir de cant, por referencia
	
	jal contador		# salta a la subrutina contador
	
fin:	li $v0, 10
	syscall

# contador es una subrutina hoja (no llama a otra subrutina), no necesita tocar la pila ni $ra.
contador:
	li $t0, 0		# contador = 0
	lw $t1, 0($a1)		# leo el contenido de $a1 = total de elem
	lw $t2, 0($a2)		# leo el contenido de $a2 = dato
loop:	beqz $t1, fin_loop	# si el total de elem es 0, ya recorrió todo	
	lw $t3, 0($a0)		# lee el primer elem	
	addi $a0, $a0, 4	# avanza el puntero
	addi $t1, $t1, -1	# resta 1 del total
	bne $t3, $t2, loop	# si $t3 != dato, salta a loop sin sumar el contador
	addi $t0, $t0, 1	# le suma 1 al contador
	j loop
	
fin_loop:
	sw $t0, 0($a3)		# guarda el contenido del contador $t0 en $a3 (dirección de cant)
	jr $ra