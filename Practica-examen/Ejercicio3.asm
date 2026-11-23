# Introducción:
# En matemática, una serie geométrica simple basada en potencias consiste en sumar
# los resultados de elevar una misma base a exponentes consecutivos. Por ejemplo, si
# la base es 2 y el exponente máximo es 3, la sumatoria es: 2^1 + 2^2 + 2^3 = 2 + 4 + 8 = 14.

# Consigna:
# Hacer un programa en assembly de MIPS R2000 que solicite por teclado dos números
# enteros estrictamente positivos: una base (B) y un exponente máximo (E). El programa 
# principal (main) debe pasarle dichos parámetros a una subrutina intermedia llamada 
# calcular_serie.
# La subrutina calcular_serie debe iterar desde 1 hasta E, y en cada iteración deberá
# invocar a una subrutina matemática llamada potencia (que recibe la base y el
# exponente actual, y devuelve el resultado de esa potencia). calcular_serie debe
# acumular la suma de todas las potencias y retornar el resultado final al programa
# principal para ser impreso en pantalla.
# El programa debe repetir toda su ejecución (pidiendo nuevos pares de números) hasta
# que el usuario ingrese un en la base, momento en el cual el programa debe finalizar.

# Ejemplo de ejecución:
# Introduzca la base: 2
# Introduzca el exponente maximo: 3
# La sumatoria de potencias es: 14
# Introduzca la base: 5
# Introduzca el exponente maximo: 2
# La sumatoria de potencias es: 30
# Introduzca la base: 0
# Fin del programa

.data
base:		.asciiz "Introduzca la base: "
exponente:	.asciiz "Introduzca el exponente máximo: "
resultado:	.asciiz "La sumatoria de potencias es: "
salto:		.asciiz "\n"
fin:		.asciiz "Fin del programa"

.text
main:
	# solicitar la base al usuario
	la $a0, base
	jal imprimir_msje

	# leer el valor de entrada del usuario
	li $v0, 5		# carga la instrucción 5 read_int
	syscall			# llamada al sistema
	move $t0, $v0		# captura el valor de la base ingresado
	move $a0, $t0		# carga el argumento -
	beqz $t0, fin_programa	# si el usuario ingresa 0, salta a fin_programa

	# solicitar el exponente al usuario
	la $a0, exponente	#cambiado a $a0 porque el syscall 4 lo exige
	jal imprimir_msje

	# leer el valor de entrada del usuario
	li $v0, 5
	syscall
	move $a1, $v0		# carga el exponente como segundo argumento en $a1

	# preparar argumentos y llamar a calcular_serie
	move $a0, $t0		# recupera la copia de la base desde $t0 hacia el primer argumento $a0
	jal calcular_serie

	# imprimir el resultado al usuario
	la $a0, resultado
	move $t3, $v0
	jal imprimir_msje
	move $a0, $t3
	li $v0, 1
	syscall

	# agregar salto de línea
	la $a0, salto
	jal imprimir_msje

	j main

fin_programa:	
	la $a0, fin
	jal imprimir_msje
	li $v0, 10
	syscall


# subrutina: imprimir_msje
# propósito: imprimir por consola una cadena de caracteres
# entrada: $a0 - la dirección de la cadena de caracteres
# salida: ninguno

imprimir_msje:
	li $v0, 4		# carga la instrucción 4 print_string
	syscall			# llamada al sistema
	jr $ra			# retorna al llamador

# subrutina: calcular_serie
# propósito: iterar desde el valor 1 hasta el valor del exponente ingresado por
# el usuario, llamar a la subrutina potencia, acumular la suma de las potencias
# y retornar el resultado final a main.
# entrada: $a0 - valor de la base; $a1 - valor del exponente
# salida: $v0 - resultado total de la sumatoria

calcular_serie:
	# -- PRÓLOGO --
	addi $sp, $sp, -12	# reservo memoria para 2 parámetros + $ra
	sw $ra, 8($sp)
	sw $s0, 4($sp)
	sw $s1, 0($sp)

	# -- CUERPO --
	move $s0, $a0		# valor de base
	move $s1, $a1		# valor de exponente (contador de vueltas)
	li $t2, 0		# acumulador

loop:	
	beqz $s1, fin_loop	# si el exponente llega a 0, salta a fin_loop
	# -- parámetros para potencia --
	move $a0, $s0		# valor base
	move $a1, $s1		# valor exponente
	jal potencia		# llama a la subrutina potencia
	add $t2, $t2, $v0	# realiza la acumulación de sumas
	addi $s1, $s1, -1	# resta una vuelta
	j loop

fin_loop:
	move $v0, $t2	# retorna el total
	# -- EPÍLOGO --
	lw $s1, 0($sp)
	lw $s0, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12

	jr $ra

# subrutina: potencia
# propósito: calcular la potencia de la base y el exponente recibidos como argumentos
# retornar el resultado.
# entrada: $a0 - base; $a1 - exponente actual
# salida: $v0 - resultado de la potencia
potencia:
	# Acumulador. Arranca en 1 porque 1 es neutro para la multiplicación.
	li $v0, 1
loop_potencia:	
	beqz $a1, fin_potencia
	mul $v0, $v0, $a0	# mul ahorra tener que extraer el resultado
	addi $a1, $a1, -1	# resta una vuelta al contador (exponente)
	j loop_potencia
fin_potencia:	
	jr $ra