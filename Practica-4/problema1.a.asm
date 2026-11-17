# 1. Implementa una subrutina en ensamblador que calcule cuántos elementos
# de un vector de enteros de dimensión n son iguales a un elemento dado:
# Parámetros de entrada a la subrutina:
# - dirección del primer elemento del vector,
# - total de elementos del vector (dimensión),
# - elemento a comparar.
# Parámetro de salida de la subrutina:
# - contador calculado.

# Realiza las siguientes implementaciones:
# a) Implementa la subrutina de forma que todos los parámetros que
# se le pasan sean por valor excepto aquéllos que obligatoriamente se
# deban pasar por referencia, y a través de registros.

.data
vector: .word 3,4,9,12,4
dato: 	.word 4
cant:	.space 4

.text
main:
	la $a0, vector		# a0 = dirección del vector por referencia
	li $a1, 5		# a1 = total de elementos del vector, por valor
	lw $a2, dato		# a2 = dato, por valor
	
	jal contador		# salta a la subrutina contador
	sw $v0, cant
	
fin:	li $v0, 10
	syscall

# contador es una subrutina hoja (no llama a otra subrutina), no necesita tocar la pila ni $ra.
contador:
	li $t0, 0		# contador = 0
loop:	beqz $a1, fin_loop	# si el total de elem es 0, ya recorrió todo	
	lw $t1, 0($a0)		# lee el primer elem	
	addi $a0, $a0, 4	# avanza el puntero
	addi $a1, $a1, -1	# resta 1 del total
	bne $t1, $a2, loop	# si $t1 != dato, salta a loop sin sumar el contador
	addi $t0, $t0, 1	# le suma 1 al contador
	j loop
	
fin_loop:
	move $v0, $t0		# guarda el contenido del contador $t0 en $v0
	jr $ra