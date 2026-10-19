# Modificar el código para:
# while (letra_actual != 0x00 && contador < 20)

.data
string:	.asciiz "Hola mundo\n"
	.align 2
length:	.space 4


.text
main:	la $t0, string
	li $t1, 0
	li $t3, 19
while:	lb $t2, ($t0)
	beqz $t2, end
	bgt $t1, $t3, end
	addi $t1, $t1, 1 # contador
	addi $t0, $t0, 1 # dirección
	j while
end:	sw $t1, length 

