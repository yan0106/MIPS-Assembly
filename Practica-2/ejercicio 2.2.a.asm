
.data
number: .word 0x3ff41      # Define una palabra en memoria llamada 'number' con el valor inicial 0x3ff41.
                           # Ocupa 4 bytes.
        .space 4           # Reserva 4 bytes adicionales justo después de 'number'. Este espacio
                           # no tiene etiqueta, pero su dirección es 'number + 4'.
.text
main:
  lw $s0, number		# Carga el valor de 'number' (0x3ff41) desde la memoria al registro $s0.
  andi $s1, $s0, 0xfffe  	# Operación AND Inmediato. El resultado se guarda en $s1.
                         	# 0xfffe es la 'máscara'.
  		    	# 0xfffe == ...0111111111111110 (en 16 bits)
  sw $s1, number+4      	# Guarda el valor resultante (de $s1) en la memoria, en el espacio
                        	# reservado 4 bytes después de 'number'.
