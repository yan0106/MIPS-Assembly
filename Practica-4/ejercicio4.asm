# Almacena en memoria una tira de caracteres de máximo 10 elementos.
# Lee la cadena de caracteres desde el teclado.
# Invierte esta cadena, almacenando la cadena resultante en las mismas
# posiciones de memoria que la original. (Sugerencia para realizar el
# ejercicio: Se apilan los elementos de la tira en la pila y, a continuación, se
# desapilan y se almacenan en el mismo orden que se extraen).

.data
msje:	.asciiz "Ingresa una cadena (max. 10 caracteres): "
cadena: .space 11	# se reserva memoria para 10 caracteres + el byte nulo
res:	.asciiz "\nEl resultado es: "

.text

main:	
	# 1. Mostrar mensaje por consola
	la $a0, msje
	li $v0, 4
	syscall

	# 2. Leer la cadena ingresada por el usuario
	la $a0, cadena
	li $a1, 11
	li $v0, 8
	syscall
	
	# 3. Crear un puntero al arreglo para recorrerlo y un contador
	la $t0, cadena		# $t0 puntero para leer la cadena
	li $t2, 0		# $t2 contador de caracteres apilados

bucle_apilar:
	lb $t1, 0($t0)		# Lee 1 carácter (byte) de la cadena
	beqz $t1, fin_apilar	# Si es el byte nulo (0x00), termina de leer
	beq $t1, 10, fin_apilar	# Si es Enter ('\n' = ASCII 10), también frena para no invertir el salto de línea

	# --- Apilar el caracter ---
	addi $sp, $sp, -4	# Baja la pila 4 bytes (manteniendo alineación)
	sb $t1, 0($sp)		# Guarda el carácter en el tope de la pila
	# --------------------------

	addi $t2, $t2, 1	# Suma 1 al contador de letras apiladas
	addi $t0, $t0, 1	# Avanza el puntero al siguiente byte de 'cadena'
	j bucle_apilar
	
fin_apilar:
	la $t0, cadena		# Se vuelve a poner el puntero al inicio de 'cadena'

bucle_desapilar:	
	beqz $t2, fin_programa	# Si el contador llega a 0, ya se sacaron todas las letras

	# --- Desapilar y guardar ---
	lb $t1, 0($sp)		# Saca el carácter del tope de la pila
	addi $sp, $sp, 4	# Sube el puntero de pila (libera 4 bytes)
	sb $t1, 0($t0)		# Sobrescribe la posición actual de 'cadena'
	# ---------------------------

	addi $t0, $t0, 1	# Avanza al siguiente byte de 'cadena'
	addi $t2, $t2, -1	# Restamos 1 al contador
	j bucle_desapilar

fin_programa:
	# Mostrar el mensaje de resultado
	la $a0, res
	li $v0, 4
	syscall

	# Mostrar por pantalla la cadena invertida
	la $a0, cadena
	li $v0, 4
	syscall
	
	# Salir del programa
	li $v0, 10
	syscall
	
