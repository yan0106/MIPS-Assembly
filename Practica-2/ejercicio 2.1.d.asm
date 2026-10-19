
.data
num1: 	.word 0x80000000
num2: 	.word 1

.text
main: 	lw $s0, num1	# en $s0, carga 0x80000000
	lw $s1, num2	# en $s1, carga 1
	subu $s0, $s0, $s1	# resta 0x80000000 - 1 = 0x7FFFFFFF, lo carga en $s0
	subu $s0, $s0, $s1	# resta 0x7FFFFFFF - 1 = 0x7FFFFFFE, lo carga en $s0
	sw $s0, num 1	# el valor de $s0 (0x7FFFFFFE), lo guarda en la direcc. de memoria de num1