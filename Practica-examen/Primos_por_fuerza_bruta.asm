# Introducción:
# Un número primo es aquel natural que solo se puede dividir por uno o si mismo. La
# detección de primos por fuerza bruta consiste en dividir el número por todos los que le
# anteceden sin incluir el 1. Si el resto es nulo se descarta porque se ha encontrado un
# divisor e implica que no es primo.

# Consigna:
# Hacer un programa en assembly de MIPS R2000 que solicite dos números enteros
# positivos y encuentre todos los primos entre ellos. Para ello deberá solicitar en main
# ambos números, comprobar que el segundo sea estrictamente mayor que el primero,
# sino informar "Error: Intervalor no creciente" y terminar si cualquier de ellos es 0.
# Luego deberá llamar a una subrutina print_primes que realizará una iteración entre
# dichos números llamando a una subrutina prime que devuelve 1 si es primo y 0 si no
# lo es. En caso de serlo se imprimirá el número seguido de espacio.

# Ejemplo de ejecución:
# Introduzca P1: 5
# Introduzca P2: 10
# 5 7
# Introduzca P1: 0
# Fin de programa

.data
msje1:	.asciiz "Ingrese el numero A: "
msje2:	.asciiz "Ingrese el numero B: "
error:	.asciiz "Error: intervalor no creciente\n"
fin:	.asciiz "Fin del programa"


.text
main:	
	# solicitar el numero A
	la $a0, msje1
	li $v0, 4
	syscall
	
	# leer el entero ingresado
	li $v0, 5
	syscall
	move $t0, $v0
	
	# rango <= 0: fin
	blez $t0, fin_main
	
	# solicitar el numero B
	la $a0, msje2
	li $v0, 4
	syscall
	
	# leer el entero ingresado
	li $v0, 5
	syscall
	move $t1, $v0
	
	# rango <= 0: fin
	blez $t1, fin_main
	
	# si B <= A, error_rango
	ble $t1, $t0, error_rango
	
	# cargar argumentos
	move $a0, $t0	# numero A
	move $a1, $t1	# numero B
	
	# llamar a prints_primes
	jal prints_primes
	
	# imprimir salto de línea
	li $a0, 10
	li $v0, 11
	syscall
	
	# repite
	j main
	
error_rango:
	# mostrar msje de error
	la $a0, error
	li $v0, 4
	syscall	
	j fin_main		

fin_main:
	# mostrar mensaje de fin
	la $a0, fin
	li $v0, 4
	syscall
	
	# salir del sistema
	li $v0, 10
	syscall
	

# Subrutina: prints_primes (no-hoja)
# Propósito: realiza una iteración entre numero A y numero B, llama a la subrutina prime e imprime
# por consola, los números primos. 
# Entrada: $a0: numero A ; $a1: numero B
# Salida: ninguna (imprime por consola)

prints_primes:
	# reservar memoria
	addi $sp, $sp, -16	# $ra + numA + numB + variable = 4 * 4 = 16
	sw $ra, 12($sp)		# resguarda $ra			
	sw $s0, 8($sp)		# numA
	sw $s1, 4($sp)		# numB
	sw $s2, 0($sp)		# variable
	
	# lógica
	move $s0, $a0		# numA
	move $s1, $a1		# numB
	li $s2, 1		# variable
	
loop:	bgt $s0, $s1, fin_loop	# si numA > numB, termina	
	move $a0, $s0		# carga como argumento numA
	move $a1, $s1		# carga como argumento numB
	jal prime
	beqz $v0, siguiente	# si $v0 = 0, no es primo, avanza
	beq $v0, $s2, imprimir	# si $v0 = 1, es primo, salta a imprimir		
	
imprimir:
	# imprimir el entero
	move $a0, $s0
	li $v0, 1
	syscall
	
	# imprimir un espacio
	li $a0, 32  		# imprime ' ' 
	li $v0, 11
	syscall
	
siguiente:
	addi $s0, $s0, 1	# le suma 1 a numA
	j loop	
	
fin_loop:
	# devolver memoria
	lw $s2, 0($sp)		# variable
	lw $s1, 4($sp)		# numB
	lw $s0, 8($sp)		# numA
	lw $ra, 12($sp)		# restaura $ra	
	addi $sp, $sp, 16
	jr $ra
	
# Subrutina: prime (hoja)
# Propósito: realiza una división entre el numero a evaluar y divisores(sin incluir el 1), arrancando en 2,
# hasta n-1
# Si el resto es nulo se descarta porque encontró un divisor.
# Entrada: $a0: numero a evaluar
# Salida: $v0 = 1 (es primo) ; $v0 = 0 (no es primo)

prime:	
	ble $a0, 1, no_primo	# caso borde: si numA = 1
	li $t0, 2		# $t0: divisor arranca en 2
	
loop_prime:
	# Si $t0 llegó hasta el num sin encontrar divisores, sig q ningún nro entre 2 y (N - 1) lo dividió	
	beq $t0, $a0, es_primo
	div $a0, $t0		# divide el numero por el divisor actual ($t0)
	mfhi $t1		# (Move From HI) carga en $t1, el Resto 
	beqz $t1, no_primo	# si el resto = 0, no es primo
	addi $t0, $t0, 1	# suma 1 al divisor
	j loop_prime
	
es_primo:
	li $v0, 1		# si es primo, devuelve 1
	jr $ra	
	
no_primo:
	li $v0, 0		# si no es primo, devuelve 0
	jr $ra
	
	
	
	
	
	
