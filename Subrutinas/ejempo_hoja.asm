# int ejemplo_hoja (int g, int h, int i, int j) {
#	int f;
#	f = (g + h) - (i +j);
#	return f;
# }

.data
# para variables globales o estáticas que existen durante toda la vida del programa

.text
ejemplo_hoja:	# Prólogo: Ajustar la pila restando al puntero $sp para hacer espacio y usar sw para guardar los registros.
		addi $sp, $sp, -12	# ajusta la pila para hacer lugar para 3 campos
		sw $t1, 8($sp)	# guarda el registro $t1 para usarlo posteriormente
		sw $t0, 4($sp)	# guarda el registro $t0 para usarlo posteriormente
		sw $s0, 0($sp)	# guarda el registro $s0 para usarlo posteriormente
		
		# Cuerpo: Utilizar los registros de argumentos ($a0 a $a3) para hacer los cálculos matemáticos.
		add $t0, $a0, $a1	# registro $t0 contiene g + h
		add $t1, $a2, $a3 	# registro $t1 contiene i + j
		sub $s0, $t0, $t1	# f = $t0 - $t1, que es (g + h) - (i + j)
		
		# Retorno de valor: Copiar el resultado final en el registro $v0, que es la convención para devolver valores.
		add $v0, $s0, $zero	 # returns f ($v0 = $s0 + 0)
		
		# Epílogo: Restaurar la pila usando lw en el orden inverso, sumar al $sp y usar la instrucción jr $ra para volver a la rutina de llamada
		lw $s0, 0($sp)	# restaura registro $s0 para el llamador
		lw $t0, 4($sp)	# restaura registro $t0 para el llamador
		lw $t1, 8($sp)	# restaura registro $t1 para el llamador
		addi $sp, $sp, 12	# ajusta la pila para eliminar 3 campos
		
		jr $ra		# salto de retorno a la rutina de llamada
		
# Optimización:
# Dado que $t0 y $t1 son temporales, no hace falta que se guarde y se restaure en la memoria.
# Se puede evitar realizar esos dos almacenamientos (sw) y esas dos cargas (lw). 
# Solo es obligatorio guardar y restaurar el registro $s0 porque es un registro preservado.