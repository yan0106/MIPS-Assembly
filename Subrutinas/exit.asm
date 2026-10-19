# Propósito: ilustrar la implementación y la llamada a un subprograma llamado 'Exit'

.text

main:	# leer un valor de entrada del usuario
	li $v0, 4
	la $a0, prompt
	syscall
	li $v0, 5
	syscall
	move $s0, $v0
	
	# imprimir el valor de vuelta al usuario
	li $v0, 4
	la $a0, result
	syscall
	li $v0, 1
	move $a0, $s0
	syscall
	
	# llamar al subprograma Exit para salir
	jal Exit
	
.data
prompt: .asciiz "Por favor introduzca un numero entero: "
result: .asciiz "\n Usted ingresó: "
	
.text
Exit:	li $v0, 10
	syscall
	