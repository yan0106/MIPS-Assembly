
.data	0x10000000
numero:  	.word 0xabcd12bd	# Número inicial
resultado:	.space 4          	# Espacio para el resultado

.text
main:
  	lw $s0, numero_original  	# Carga el número en $s0 = 0xabcd12bd
  	# Máscara = 0xFFFFFD77 (1s en todos lados excepto bits 3, 7, 9 que son 0s)
	li $t0, 0xFFFFFD77 		# Carga la máscara de 32 bits en $t0
	and $s1, $s0, $t0        	# Aplica la máscara usando AND (entre registros). $s1 = $s0 AND máscara
	sw $s1, resultado      	# Guarda el valor modificado en 'resultado'