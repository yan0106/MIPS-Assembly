.text
main:
	# leer un valor de entrada del usuario
	la $a0, prompt 
	jal PromptInt
	move $s0, $v0
	
	# imprimir el valor de vuelta al usuario
	jal PrintNewLine
	la $a0, result
	move $a1, $s0
	jal PrintInt

	# llamar al subprograma Exit para salir
	jal Exit
.data
prompt: .asciiz "Por favor introduzca un numero entero: "
result: .asciiz "Ingresaste: "

# subprograma: PrintNewLine
.text
PrintNewLine:
	li $v0, 4
	la $a0, __PNL_newline
	syscall
	jr $ra
	
.data
__PNL_newline: .asciiz "\n"

# subprograma: PrintInt 
# proposito: imprimir una cadena en la consola
# entrada: $a0 - la dirección de la cadena a imprimir. 
# $a1 - el valor del entero a imprimir
# retorna: ninguno 
# efecto: La cadena se imprime seguida del valor del entero
.text 
PrintInt: 
	# imprimir la cadena. La dirección de la cadena ya está en $a0 
	li $v0, 4 
	syscall
	# imprimir el entero. El valor del entero está en $a1, y se moverá primero a $a0. 
	move $a0, $a1 
	li $v0, 1 
	syscall
	# return
 	jr $ra
 	
# subprograma: PromptInt
# propósito: imprimir al usuario para la entrada de un numero entero y para devolver el valor
# de la entrada al llamador.
# entrada: $a0 - la dirección de la cadena a imprimir
# retorna: $v0 - el valor ingresado por el usuario
# efectos: la cadena se imprime seguida del valor entero
.text 
PromptInt: 
	# imprime el mesaje que ya está en $a0 
	li $v0, 4 
	syscall
	# lee el valor entero. Tener en cuenta que al final de la syscall el valor
	# ya está en $v0, por lo que no hay necesidad de moverlo a otro
	# lugar.
	li $v0, 5 
	syscall
	#return 
	jr $ra

# subprograma: PrintString
# propósito: imprimir una cadena en la consola
# entrada: $a0 - la dirección de la cadena a imprimir
# retorna: ninguno
# efecto: la cadena se imprimirá en la consola
.text 
PrintString: 
	addi $v0, $zero, 4
	syscall 
	jr $ra

# subprograma: Exit
.text
Exit:
	li $v0, 10
	syscall