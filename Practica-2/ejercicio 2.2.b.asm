
.data
number: .word 0x3ff41      # Valor original: 0x0003ff41
        .space 4           # Espacio para el resultado en number + 4
.text
main:
  	lw $s0, number         # Carga 0x0003ff41 en $s0

  	# Modificar según las reglas:
  	# Mantener bits superiores -> ori con 0x0000 no los afecta
  	# Poner bits 15-1 a uno -> ori con 0xFFFE lo hace
  	# Mantener bit 0 -> ori con 0x...0 lo hace (incluido en 0xFFFE)
  
  	ori $s1, $s0, 0xFFFE   # $s1 = $s0 OR 0x0000FFFE
  	sw $s1, number+4       # Guardar el resultado en la siguiente palabra

  	# --- Finalizar programa ---
  	li $v0, 10
  	syscall