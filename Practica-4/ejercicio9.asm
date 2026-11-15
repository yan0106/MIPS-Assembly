# Comprueba qué hay almacenado en el tope de la pila después de ejecutar las
# dos primeras instrucciones del programa

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
	
# Después de ejecutar addi $sp, $sp, -4 y sw $ra, 0($sp):
# En el tope de la pila (dirección 0x7fffeff8 apuntada por $sp) queda almacenado
# el contenido del registro $ra: en MARS este valor es 0x00000000 (mientras que 
# en XSPIM sería la dirección de retorno al código de arranque del simulador).
# Además, $sp queda en 0x7fffeff8 y el PC avanza a 0x00400008.
