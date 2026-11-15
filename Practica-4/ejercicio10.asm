# Comprueba el contenido de los registros $ra y PC antes y después de ejecutar 
# la instrucción jal subr

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
	
# Antes de jal subr: pc = 0x00400020 y $ra = 0x00000000.   
# Después de jal subr: pc = 0x00400040 y $ra = 0x00400024.