# Escriba un programa completo en MIPS R2000 que procese una cadena de texto
# almacenada en memoria,cuente sus vocales y convierta las vocales minúsculas a 
# mayúsculas utilizando operaciones lógicas a nivel de bit.

.data
cadena:		.asciiz "Arquitectura de las computadoras I"
msje_vocales:	.asciiz "Cantidad de vocales: "
msje_cadena:	.asciiz "La cadena modificada es: "
salto:		.asciiz "\n"
		.align 2
vocales: 	.space 4	# para almacenar la cant. de vocales

.text
main: 	# cargar cadena y llamar a subrutina para procesarla
	la $a0, cadena
	jal modif_cadena
	
	# imprimir msje_vocales
	la $a0, msje_vocales
	li $v0, 4
	syscall
	
	# imprimir cant. de vocales
	lw $a0, vocales
	li $v0, 1
	syscall
	
	# imprimir msje_cadena
	la $a0, msje_cadena
	li $v0, 4
	syscall
	
	# imprimir la cadena modificada
	la $a0, cadena
	li $v0, 4
	syscall

	# salir del sistema
	li $v0, 10
	syscall
	
# Subrutina: modif_cadena
# Propósito: procesa la cadena almacenada en memoria, cuenta cuántas vocales tiene,
# guarda esa cant de vocales en 'vocales', cambia las vocales minúsculas a mayúsculas
# y sobreescribe el resultado en 'cadena'.
# Entrada: $a0: dirección de inicio de cadena
# Salida: ninguna porque almacena directamente el resultado en memoria

modif_cadena:
	addi $sp, $sp, -16	# reserva memoria para $ra, puntero, contador y c actual
	sw $ra, 12($sp)		# preserva el registro $ra
	sw $s0, 8($sp)
	sw $s1, 4($sp)
	sw $s2, 0($sp)
	
	move $s0, $a0		# puntero
	li $s1, 0		# contador
	
loop:	
	lb $s2, ($s0)		# carga el contenido del primer byte, posición[0]	
	beqz $s2, fin_loop 	# si el contenido de $s2 es 0x00, salta a fin_loop
	move $a0, $s2		# $a0: caracter actual
	jal es_vocal
	beqz $v0, siguiente	# si no es vocal, salta a siguiente
	add $s1, $s1, 1		# si es_vocal: 1, suma 1 al contador de vocales
	blt $s2, 'a', siguiente
	bgt $s2, 'z', siguiente
	andi $t0, $s2, 0xDF	# modifica la vocal minuscula a mayuscula con la máscara
	sb $t0, ($s0)		# sobreescribe en 'cadena'

siguiente:
	add $s0, $s0, 1		# avanza el puntero
	j loop	

fin_loop:
	sw $s1, vocales
	
	lw $s2, 0($sp)
	lw $s1, 4($sp)
	lw $s0, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16
	
	jr $ra			# regresa a main
		

	

	
	
# en MARS se pueden cargar caracteres directamente usando comillas simples,
# por ejemplo li $t3, 'a', o usar sus valores ASCII en hexadecimal/decimal.
	
# En ASCII, todas las letras mayúsculas tienen el bit 5 (posición 0x20,
# binario 0010 0000) apagado en 0, mientras que todas las minúsculas lo 
# tienen encendido en 1.