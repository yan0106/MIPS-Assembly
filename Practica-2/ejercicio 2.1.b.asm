
.data
num1:	.word 0x2

.text
main: 	lw $s0, num1
	add $s0, $s0, $s0
	
# Los registros fuente y distino no tienen porque ser distintos. La suma de s0 más s0,
# se almacena en s0. 