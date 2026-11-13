# Modifica el programa anterior para que en lugar de actualizar el
# puntero de pila cada vez que se pretende apilar un registro en la misma, se realice una
# sola vez al principio y después se apilen los registros en el mismo orden.

.text

main:	li $t0, 10
	li $t1, 13
	addi $sp, $sp, -8	# actualizar el sp
	sw $t0, 0($sp)		# apilar t0
	sw $t1, 4($sp)		# apilar t1
	
