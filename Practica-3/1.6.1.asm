
.data
bool:	.byte 0,1,1,1,0
res:	.space 3

.text
	la $t0, bool	# dirección de bool
	lb $t1, ($t0) 	# en $t1 carga el valor de bool[0]
	lb $t2, 4($t0)	# en $t2 carga el valor de bool[4]
	and $t3, $t1, $t2	# en $t3 guarda la op AND entre los registros
	la $t4, res	# dirección de res
	sb $t3, ($t4)	# guarda en res[0], el valor de $t3
	
	lb $t5, 1($t0)	# en $t5 carga el valor de bool[1]
	lb $t6, 3($t0)	# en $t6 carga el valor de bool[3]
	or $t7, $t5, $t6
	sb $t7, 1($t4)
	
	lb $t8, 2($t0)	# en $t8 carga el valor de bool[2]
	and $t9, $t5, $t8	# op and entre bool[1], bool[2]
	or $s0, $t1, $t9	# or entre bool[0], $t9 (resultado de la op and)
	sb $s0, 2($t4)
	
end:	li $v0, 10
	syscall
 

