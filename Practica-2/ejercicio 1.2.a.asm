
.data			# dirección: 0x10010000
number: .word 0x12345678	# reserva 4 bytes en memoria

.text 			# dirección: 0x00400000
main: la $t0, number		# carga la dirección de number (0x10010000)
      lw $s0, 0($t0)		# carga el valor desde la dirección en $t0 hacia $s0