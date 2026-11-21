# SUMA DE CUADRADOS
# Desarrollar un programa que calcule la suma de los cuadrados de todos los números enteros 
# comprendidos en un intervalo cerrado [A, B]: 
# Resultado = A^2 + (A+1)^2 + ... + B^2 
# Estructura modular: 
# 1. main: solicita los enteros A y B. Si alguno es <= 0, imprime "Fin del programa" y termina. 
# Si A > B, imprime un mensaje de error y vuelve a pedir ambos números. 
# En caso contrario, llama a suma_cuadrados(A, B), imprime el resultado devuelto en $v0 y repite. 
# 2. suma_cuadrados(A, B): recibe A en $a0 y B en $a1. Recorre los enteros i desde A hasta B inclusive, 
# llama a cuadrado(i) en cada iteración, acumula los resultados y devuelve la suma total en $v0. 
# 3. cuadrado(X): subrutina hoja que recibe X en $a0, calcula X^2 (con mul) y lo retorna en $v0.

.data
msje_entero:	.asciiz "Ingrese un entero: "
msje_fin:	.asciiz "Fin del programa"
msje_error:	.asciiz "El número no es válido. "
msje_res:	.asciiz "Resultado: "
		.align 2
resultado:	.space 4

.text
main:	# solicitar un entero A
	la $a0, msje_entero
	li $v0, 4
	syscall
	# leer un entero y guardarlo
	li $v0, 5
	syscall
	move $t0, $v0
	# validar rango
	blez $t0, fin_programa		# si A <= 0

	# solicitar un entero B
	la $a0, msje_entero
	li $v0, 4
	syscall
	# leer un entero y guardarlo
	li $v0, 5
	syscall
	move $t1, $v0
	# validar rango
	blez $t1, fin_programa		# si B <= 0
	# si A > B
	bgt $t0, $t1, error
	
	# si A y B están ok
	move $a0, $t0		# $a0: A
	move $a1, $t1		# $a1: B
	jal suma_cuadrados
	# imprimir el resultado
	# repite

fin_programa:
	# imprimir msje_fin
	la $a0, msje_fin
	li $v0, 4
	syscall
	# salir del programa
	li $v0, 10
	syscall
		
error:	la $a0, msje_error
	li $v0, 4
	syscall
	j main

# Subrutina: suma_cuadrados
# Propósito: recorrer los enteros i desde A hasta B inclusive, llamar a cuadrado(i)
# en cada iteración, acumular los resultados y devolver la suma total en $v0.
# Entrada: $a0: A ; $a1: B
# Salida: $v0: suma total

# es una subrutina anidada, debe usar stack y salvar $ra

suma_cuadrados:
	addi $sp, $sp, -16	# memoria para 2 argumentos + 1 variable + $ra
	sw $ra, 12($sp)		
	sw $s0, 8($sp)
	sw $s1, 4($sp)
	sw $s2, 0($sp)		
	
	move $s0, $a0		# valor de A = i
	move $s1, $a1		# valor de B
	
	# lógica
	li $s2, 0		# acumulador
loop:	bgt $s0, $s1, fin_loop	# si A > B, terminó, salta a fin_loop
	jal cuadrado
	add $s2, $s2, $v0	# el resultado devuelto en $v0, lo acumula en $s2
	add $s0, $s0, 1		# avanza i+1
	move $a0, $s0		# copia en $a0, el valor actual de i, para enviarlo como parámetro
	j loop	

fin_loop:
	move $v0, $s2		# devuelve el acumulado en $v0	
	lw $s2, 0($sp)
	lw $s1, 4($sp)
	lw $s0, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16
	jr $ra			# vuelve a main
	
# Subrutina: cuadrado(X)
# Propósito: recibe x, calcula X^2 y lo retorna
# Entrada: $a0: x
# Salida: $v0: resultado de la operación

cuadrado:
	mul $v0, $a0, $a0	# $v0: resultado de $a0 * $a0
	jr $ra
	