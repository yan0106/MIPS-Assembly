
.data
num1:   .word 0x7fffffff  # Dividendo (2147483647)
num2:   .word 16          # Divisor (16)
        .space 8          # Espacio para guardar Cociente (en num2+4) y Resto (en num2+8)

.text
main:
  	lw $s0, num1      # Carga el dividendo en $s0
  	lw $s1, num2      # Carga el divisor en $s1
  	div $s0, $s1      # Divide $s0 / $s1 = Cociente -> lo, Resto -> hi
  	mflo $t0          # Mueve el Cociente desde 'lo' a $t0
  	mfhi $t1          # Mueve el Resto desde 'hi' a $t1
  	sw $t0, num2+4    # Guarda el Cociente (de $t0) en la primera palabra reservada
  	sw $t1, num2+8    # Guarda el Resto (de $t1) en la segunda palabra reservada

  	# --- Finalizar programa ---
  	li $v0, 10
  	syscall
