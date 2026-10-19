
.data 	0x10010002
valores: 	.byte 0x10, 0x20, 0x30, 0x40	# reserva 4 bytes. Ocupa: 0x10010002 - 0x10010005

.text
main: 	la $s0, valores
	lb $s1, 0($s0)
	lb $s2, 1($s0)
	lb $s3, 2($s0)
	lb $s4, 3($s0)
	li $t1, 0x10010010 		# Carga en $t1, la dirección 0x10010010
	sb $s1, 0($t1)
	sb $s2, 1($t1)
	sb $s3, 2($t1)
	sb $s4, 3($t1)