
.data
number:	.word 0x3ff41      # Valor original: 0x0003ff41
        	.space 4           # Espacio para el resultado en number + 4
mascara: 	.word 0xFFFF0001   # Se puede definir aquí o cargar con li

.text
main:
  lw $s0, number        	# Carga 0x0003ff41 en $s0

  # Cargar la máscara de 32 bits
  li $t0, 0xFFFF0001   	# Carga la máscara en $t0 (podría usar lw $t0, mascara si se define en .data)

  # Aplicar la máscara usando AND entre registros
  and $s1, $s0, $t0      	# $s1 = $s0 AND $t0

  sw $s1, number+4       	# Guardar el resultado en la siguiente palabra

  # --- Finalizar programa ---
  li $v0, 10
  syscall