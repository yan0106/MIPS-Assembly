
.text
main:
	# leer un valor de entrada del usuario
	la $a0, prompt 
	jal PrintString
	li $v0, 5
	syscall
	move $s0, $v0
	
	# imprimir el valor de vuelta al usuario
	jal PrintNewLine
	la $a0, result 
	jal PrintString
	li $v0, 1
	move $a0, $s0
	syscall
	
	# llamar al subprograma Exit para salir
	jal Exit
.data
prompt: .asciiz "Por favor introduzca un nnumero entero: "
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

# subprograma: PrintString
# propósito: imprimir una cadena en la consola
# entrada: $a0 - la dirección de la cadena a imprimir
# devuelve: ninguno
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
	
