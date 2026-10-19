
.data 0x10000000 	# Comienza en la dirección 0x10000000
         .align 2	# Para asegurar de que comience en múltiplo de 4
vectorA: .space 80 	# Reserva espacio para 20 palabras (4 bytes * 20 = 80 bytes)
         .align 2	# Para asegurar que comience en múltiplo de 4
vectorB: .space 80 	# Idem