# ¿Cuál es el contenido de los registros PC y $ra antes y después
# de ejecutar la instrucción jr $ra?

.text

main:
	li $a0, 10
	li $a1, 20
	add $v1, $a0, $a1
	
	li $v0, 10      # Equivalente en MARS al jr $ra de XSPIM
    	syscall

# Respondido desde la teoría, MARS no tiene jal main ni jr $ra:  	  	
# Antes de ejecutar jr $ra:
# PC: Contiene la dirección de memoria de la propia instrucción jr $ra (la última 
# instrucción de main).   
# $ra: Sigue conservando la dirección de retorno al código de arranque del simulador
# (la misma que cargó jal main, ya que no se llamó a ninguna subrutina intermedia que lo pisara).

# Después de ejecutar jr $ra:
# PC: Toma el valor almacenado en $ra (la dirección de retorno al código del sistema), 
# devolviendo el control al simulador para que finalice el programa.
# $ra: Mantiene exactamente el mismo valor (la instrucción jr solo lee $ra para copiarlo
# al PC, no lo modifica).

 