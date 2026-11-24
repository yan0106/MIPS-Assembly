# La función de Ackermann
# Introducción: El matemático alemán Wilhelm Ackermann definió una función recursiva
# A(m, n) sobre enteros no negativos que se caracteriza por su rápido crecimiento. La
# función se define formalmente según las siguientes reglas: 
# A(0, n) = n + 1 
# A(m, 0) = A(m - 1, 1) (para m > 0)
# A(m, n) = A(m - 1, A(m, n - 1)) (para m > 0 y n > 0)

# Consigna: Hacer un programa en assembly de MIPS R2000 que solicite dos valores M y
# N, enteros no negativos, y calcule el valor de la función mediante una subrutina recursiva
# ackermann que reciba los parámetros M y N, respetando las convenciones. Dado que la
# función realiza llamadas recursivas y anidadas, la subrutina debe respetar los convenios
# establecidos y los argumentos necesarios en cada nivel de recursión. Cuando la subrutina
# devuelva el resultado, debe retornarlo al programa principal respetando los ejemplos de
# ejecución para imprimirlo y repetir la ejecución al menos que alguno de los dos valores
# sea negativo (si un valor es menor que 0 no tiene sentido calcular la función), con lo cual
# el programa debe finalizar.

# Pseudocódigo (help):
# ackermann(m, n):
# si m == 0:
	# retornar n + 1
# si n == 0:
	# retornar ackermann(m - 1, 1)
# temp = ackermann(m, n - 1)
# retornar ackermann(m - 1, temp)

.data
M:	.asciiz "Introduzca M: "
N:	.asciiz "Introduzca N: "
res:	.asciiz "El resultado es: "
fin:	.asciiz "Fin de programa"

.text
main:	
	# solicitar M
	la $a0, M
	li $v0, 4
	syscall
	
	# leer el valor ingresado
	li $v0, 5
	syscall
	move $t0, $v0
	
	# validar M (si M < 0, finaliza el programa)
	bltz $t0, fin_main
	
	# solicitar N
	la $a0, N
	li $v0, 4
	syscall
	
	# leer el valor ingresado
	li $v0, 5
	syscall
	move $t1, $v0

	# validar N ( si N < 0, finaliza el programa)
	bltz $t1, fin_main
		
	# cargar los argumentos
	move $a0, $t0
	move $a1, $t1
	
	# llamar a ackermann
	jal ackermann
	
	# cargar el resultado
	move $t0, $v0
	
	# imprimir res
	la $a0, res
	li $v0, 4
	syscall
	
	# imprimir el valor 
	move $a0, $t0
	li $v0, 1
	syscall
	
	# imprimir salto de linea
	li $a0, 10		# '\n' = 10 en ASCII
	li $v0, 11		# syscall 11 : print_character
	syscall
	
	# repetir
	j main
	
fin_main:
	# imprimir fin
	la $a0, fin
	li $v0, 4
	syscall
	
	# salir del programa				
	li $v0, 10
	syscall


# Subrutina: ackermann
# Propósito: recibe los parámetros M y N, los procesa y devuelve el resultado a main.
# Entrada: $a0: parámetro M / $a1: parámetro N
# Salida: $v0: resultado obtenido 

ackermann:
	# reservar memoria stack
	addi $sp, $sp, -16
	sw $ra, 12($sp)		# para $ra
	sw $s0, 8($sp)		# para M
	sw $s1, 4($sp)		# para N
	sw $s2, 0($sp)		# para temp
	
	# salvar parámetros
	move $s0, $a0		# $s0: M
	move $s1, $a1		# $s1: N
	
	# lógica
	beqz $s0, return1	# si $s0:M == 0, salta a return1
	beqz $s1, return2	# si $s1:N == 0, salta a return2
	# temp = ackermann(m, n - 1)
	li $s2, 0		# temp
	addi $s1, $s1, -1	# N - 1
	move $a0, $s0		# carga M en $a0
	move $a1, $s1		# carga (n - 1) en $a1
	jal ackermann
	move $s2, $v0		# tem = ackermann (m, n - 1)
	j return3

fin_ackermann:
	# devolver memoria
	lw $s2, 0($sp)
	lw $s1, 4($sp)
	lw $s0, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16
	# volver a main
	jr $ra

return1:
	# retornar (n + 1)
	add $s1, $s1, 1		# N + 1
	move $v0, $s1
	j fin_ackermann

return2:
	# retornar ackermann(m - 1, 1)
	addi $s0, $s0, -1	# M - 1
	li $s1, 1		# N = 1
	move $a0, $s0		# carga el valor de M en $a0
	move $a1, $s1		# carga el valor de N en $a1
	jal ackermann		# llama recursivamente a ackermann
	j fin_ackermann
	
return3: 
	# retornar ackermann(m - 1, temp)
	addi $s0, $s0, -1	# (m - 1)
	move $a0, $s0
	move $a1, $s2
	jal ackermann
	j fin_ackermann
			