
.data
num1: 	.word 0x2
num2: 	.word 0x4
num3: 	.space 4

.text
main: 	lw $s0, num1
	lw $s1, num2
	add $s2, $s0, $s1
	sw $s2, num3

# Se cargan dos nros. enteros en los registros $s0 y $s1, add suma el contenido de s0 y s1
# colocando el resultado en s2 y lo guarda en la posición de memoria de num3