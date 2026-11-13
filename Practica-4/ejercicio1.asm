# El siguiente código muestra cómo se puede realizar el apilado 
# de los registros $t0 y $t1 en la pila

.text

main:	li $t0, 10
	li $t1, 13
	addi $sp, $sp, -4	# actualizar el sp
	sw $t0, 0($sp)		# apilar t0
	addi $sp, $sp, -4	# actualizar el sp
	sw $t1, 0($sp)		# apilar t1
	
# el contenido del registro $t0 se almacena en: 0x7ffefef0 + 0x18 = 0x7ffeff08
# el contenido del registro $t1 se almacena en: 0x7ffefef0 + 0x14 = 0x7ffeff04