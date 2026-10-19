# int fact (int n) {
#	if (n < 1) return (1);
#	    else return (n * fact(n - 1));
# }

.data

.text
fact:	addi $sp, $sp, -8	# ajustar l apila para 2 elementos
	sw $ra, 4($sp)	# guardar la dirección de retorno
	sw $a0, 0($sp)	# guardar el argumento n
	
	slti $t0, $a0, 1	# test para n < 1
	beq $t0, $zero, L1	# si n >= 1, ir a L1
	
	addi $v0, $zero, 1	# devolver 1
	addi $sp, $sp, 8	# eliminar 2 elementos de la pila
	jr $ra		# retornar al llamador
	
L1: 	addi $a0, $a0, -1	# n >= 1: el argumento toma el valor (n - 1)
	jal fact		# llamar a fact con (n - 1)
	
	lw $a0, 0($sp)	# retorno de jal: restaura el argumento n
	lw $ra, 4($sp)	# restaura la dirección de retorno
	addi $sp, $sp, 8	# ajusta el puntero de pila para eliminar 2 elementos
	
	mul $v0, $a0, $v0	# devuelve n * fact (n -1)
	jr $ra		# retorna al llamador
	
	