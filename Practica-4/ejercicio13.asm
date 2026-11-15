# Añade el código necesario para realizar las siguientes modificaciones sobre
# el código original:
# La subrutina subr debería calcular la siguiente operación dato1/dato2. Esta
# división sólo se realizará si ambos operandos son mayores que 0. La comprobación se
# realizará en una segunda subrutina llamada comp que devolverá un 1, si ambos datos,
# dato1 y dato2 son mayores que 0, y un 0 en caso contrario.

.data

res:	.space 4
dato1:	.word 10
dato2:	.word 20

.text
main:	addi $sp, $sp, -4	# apilar dirección de retorno
	sw $ra, 0($sp)
	lw $a0, dato1($0)
	lw $a1, dato2($0)
	jal subr
	sw $v0, res($0)
	
fin:	lw $ra, 0($sp)		# desapilar dir. de retorno
	addi $sp, $sp, 4
	li $v0, 10		# equivalente al jr $ra del simulador XSPIM
	syscall
	
# Subrutina: subr
# Propósito: calcula la operación dato1/dato2. Esta solo se realiza si ambos operandos son > 0.
# Entrada: $a0 = dato1, $a1 = dato2
# Salida: $v0 = resultado de la division o -1.

# Como subr llama a otra subrutina (comp), subr NO es una subrutina hoja; 
# está obligada a apilar $ra al empezar y desapilarlo antes de su propio jr $ra

subr:	addi $sp, $sp, -4	# reservo memoria en la pila
	sw $ra, 0($sp)		# guardo $ra en la pila
	
	jal comp
	beqz $v0, return
	div $v0, $a0, $a1
	j fin_s
	
return:	li $v0, -1

fin_s:	lw $ra, 0($sp)		# cargo la dirección de retorno en registro de la cpu
	addi $sp, $sp, 4	# devuelvo memoria a la pila
	jr $ra

# Subrutina: comp
# Propósito: compara si dato1 > 0 y dato2 > 0, en caso de serlo ambos, retorna 1
# en caso contrario, retorna 0
# Entrada: a0 = dato1 ; a1: dato2
# Salida: $v0 = 1 o 0

# Como comp es una subrutina hoja (no llama a ninguna otra subrutina), no necesita
# salvar ni restaurar $ra en la pila, con terminar ejecutando jr $ra alcanza.
	
comp:	li $t0, 0		# variable1 
	li $t1, 0 		# variable2
	sgt $t0, $a0, $t0	# si dato1 > 0 = 1 en $t0, sino 0
	sgt $t1, $a1, $t1 	# si dato2 > 0 = 1 en $t1, sino 0
	and $v0, $t0, $t1	# guarda 1 en $v0 solo si ambos ($t0 y $t1) son 1; si alguno es 0, guarda 0
	jr $ra			# salta a subr
	
	