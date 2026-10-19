
.data		0x10000000
numero:  		.word 0xff0f1235  # Número inicial
resultado:        	.space 4          # Espacio para el resultado

.text
main:
	lw $s0, numero	  # $s0 = 0xff0f1235
	li $t0, 0x288          # Carga la máscara XOR (1s en bits 3, 7, 9), $t0 = 0x00000288
	xor $s1, $s0, $t0      # Aplica XOR para invertir los bits, $s1 = $s0 XOR máscara
	sw $s1, resultado      # Guarda el valor modificado

