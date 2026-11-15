# Comprueba qué contiene el registro $ra y el PC antes y después de ejecutar la
# instrucción jal main

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

# MARS no inserta jal main antes de empezar.
# PC arranca directamente en 0x00400000 y $ra en 0x00000000.
# Después de la ejecución de main, pc toma la dirección de inicio de main y $ra guarda
# la dirección de la instrucción siguiente del código de arranque del simulador
# (donde va a regregar al finalizar todo).