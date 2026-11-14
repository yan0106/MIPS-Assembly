# Modifica el contenido de los registros $t0 y $t1, realizando algunas operaciones sobre ellos.
# Recupera el contenido inicial de estos registros desapilándolos de la pila, y
# actualiza el puntero de pila correctamente (limpiar la pila)

.text

main:	li $t0, 10
	li $t1, 13
	addi $sp, $sp, -4	# actualizar el sp
	sw $t0, 0($sp)		# apilar t0
	addi $sp, $sp, -4	# actualizar el sp
	sw $t1, 0($sp)		# apilar t1
	
	# Modificar el contenido de los registros
	addi $t0, $t0, 2	# suma 2 (ahora vale 12)
	subi $t1, $t1, 3	# resta 3 (ahora vale 10)
	
	# Recuperar los datos originales y limpiar la pila
	lw $t1, 0($sp)		# desapila
	addi $sp, $sp, 4	# libera espacio
	lw $t0, 0($sp)		# desapila
	addi $sp, $sp, 4	# libera espacio
	

# Luego de ejecutar el programa, $t0 y $t1 contienen los datos iniciales que se habían cargado.
# $sp es el mismo antes y después de la ejecución. 