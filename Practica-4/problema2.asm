# Implementa una subrutina en ensamblador, tal que dado un vector de
# enteros de dimensión n obtenga el elemento (i) de dicho vector. La
# subrutina tendrá como parámetros de entrada: la dirección del vector, la
# dimensión del mismo y el índice del elemento a devolver. La subrutina
# devolverá el elemento i-ésimo. Realiza la llamada y el retorno a la
# subrutina según el convenio establecido.

.data
vector:		.word 2,5,7,12,78
elemento:	.space 4

.text
main: 	la $a0, vector		# dirección del vector
	li $a1, 5		# dimensión n
	li $a2, 3		# índice (i) del elemento
	
	jal iesimo
	
fin:	sw $v0, elemento
	li $v0, 10
	syscall
	
iesimo:	bltz $a2, return
	bge $a2, $a1, return
	li $t0, 4
	mul $t1, $a2, $t0
	add $a0, $a0, $t1
	lw $v0, 0($a0)
	jr $ra

return: li $v0, -1
	jr $ra