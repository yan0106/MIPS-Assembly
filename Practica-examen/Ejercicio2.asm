
.data
vector:		.word 10, 20, 30, 40, 50

.text		# cargar parámetros
		la $a0, vector	# dirección del vector
		li $a1, 5		# cantidad de elementos
		li $a2, 5		# constante para sumar
		
		# llamar a la subrutina
		jal modificar_vector
		
		# salir del programa
		li $v0, 10
		syscall

# subrutina: modificar_vector
# propósito: iterar sobre el vector, enviarle cada elemento individual a la subrutina 
# sumar_constante y guardar la suma devuelta en la posición correspondiente del 
# vector en la memoria
# entrada: $a0 - dirección del vector
# $a1 - cantidad de elementos
# $a2 - constante para sumar
# salida: ninguna (modifica la memoria directamente)
modificar_vector:	# -- PROLOGO --
		addi $sp, $sp, -16
		sw $ra, 12($sp) 	# registro de retorno
		sw $s0, 8($sp)	# para la dirección del vector
		sw $s1, 4($sp)	# para la cantidad de elementos
		sw $s2, 0($sp)	# para la constante
		
		# -- CUERPO --
		move $s0, $a0	# mueve la dirección del vector
		move $s1, $a1	# mueve la cantidad de elementos
		move $s2, $a2	# mueve la constante
		
loop:		
		beqz $s1, fin_loop		
		lw $t0, 0($s0)	# lee un elemento del vector		
		move $a0, $t0	# carga el elemento para la subrutina sumar_constante
		move $a1, $s2	# carga la constante para la subrutina sumar_constante 
		jal sumar_constante
		move $t0, $v0	# captura el resultado de la suma
		sw $t0, 0($s0)	# guarda en memoria el resultado
		addi $s0, $s0, 4	# apunta al siguiente elemento
		addi $s1, $s1, -1 	# resta una vuelta
		j loop
		
fin_loop:		# -- EPILOGO --		
		lw $s2, 0($sp)	# primero recuperamos todo
		lw $s1, 4($sp)
		lw $s0, 8($sp)
		lw $ra, 12($sp)
		addi $sp, $sp, 16	# último liberamos los 16 bytes de la pila
		
		jr $ra
		
# subrutina: sumar_constante
# propósito: sumarle a cada elemento del vector, la constante que recibe por parámetro y
# devolver el resultado de cada suma.
# entrada: $a0 - elemento del vector ; $a1 - constante para sumar
# salida: $v0 - resultado de la suma
sumar_constante:	
		add $t0, $a0, $a1	# suma el elemento recibido ($a0) + 5 $(a1)
		move $v0, $t0	# mueve el resultado a $v0 para devolverlo
		jr $ra		# retorna a modificar_vector

# se puede optimizar:
# add $v0, $a0, $a1    # Suma $a0 y $a1, y guarda el resultado directo en $v0
		
		
		
		
		
		