# Reinicializa el simulador, carga el programa de nuevo y
# ejecútalo todo completo. Comprueba que la ejecución termina correctamente sin que
# salga el mensaje de error que salía en ejecuciones anteriores cuando no se incluía la
# instrucción jr $ra

.text

main:
	li $a0, 10
	li $a1, 20
	add $v1, $a0, $a1
	
	li $v0, 10      # Equivalente en MARS al jr $ra de XSPIM
    	syscall
    	
# En la teoría / XSPIM: Al incluir jr $ra al final de main, el programa devuelve el control 
# a la rutina de salida del sistema operativo, terminando la ejecución limpiamente sin mostrar
# ningún mensaje de error de memoria o instrucción inválida.   

# En MARS 4.5: Como MARS no tiene rutina de retorno en $ra, el equivalente para terminar 
# limpiamente sin errores es reemplazar jr $ra por la llamada al sistema de salida. 