
.data
num1:	.word 2147483647 # El máximo entero positivo representable en 32 bits con signo (0x7FFFFFFF)

.text
main: 	lw $s0, num1
	addiu $s1, $s0, 1 # Suma 1 SIN verificar desbordamiento
	
# En el registro $s1 = 0x80000000