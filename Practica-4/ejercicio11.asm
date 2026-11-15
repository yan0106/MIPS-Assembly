# Comprueba el contenido de los registros $ra y PC antes y después de ejecutar la
# instrucción jr $ra que está en la subrutina subr.

.data

suma:	.space 4
dato1:	.word 10
dato2:	.word 20

.text
main:	addi $sp, $sp, -4	# apilar dirección de retorno
	sw $ra, 0($sp)
	lw $a0, dato1($0)
	lw $a1, dato2($0)
	jal subr
	sw $v0, suma($0)
	lw $ra, 0($sp)		# desapilar dir. de retorno
	addi $sp, $sp, 4
	li $v0, 10
	syscall

subr:	add $v0, $a0, $a1
	jr $ra

# Antes de ejecutar jr $ra: 
# pc = 0x00400044 (la dirección donde está almacenada la instrucción jr $ra dentro de subr).   
# $ra = 0x00400024 (conserva la dirección de retorno en main).

# Después de ejecutar jr $ra:
# pc pasa a 0x00400024 (toma el valor de $ra, saltando de vuelta a main en la
# instrucción sw $v0, suma($0)).   
# $ra segue valiendo 0x00400024 (no se modifica al hacer jr).
