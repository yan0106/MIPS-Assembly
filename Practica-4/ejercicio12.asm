# Comprueba el contenido de los registros $ra y PC antes y
# después de ejecutar la instrucción jr $ra que está en la subrutina main. ¿Qué
# hubiera ocurrido si antes de ejecutar la instrucción jr $ra de esta subrutina main
# no se hubiese desapilado el contenido del registro $ra?

.data

suma:	.space 4
dato1:	.word 10
dato2:	.word 20

.text
main:	addi $sp, $sp, -4	# apilar dirección de retorno
	sw $ra, 0($sp)
	lw $a0, dato1($0)
	lw $a1, dato2($0)
	jal subr
	sw $v0, suma($0)
	lw $ra, 0($sp)		# desapilar dir. de retorno
	addi $sp, $sp, 4
	li $v0, 10		# equivalente al jr $ra del simulador XSPIM
	syscall

subr:	add $v0, $a0, $a1
	jr $ra
	
# 1. Contenido de $ra y PC antes y después de jr $ra en main:
# Como en MARS reemplazamos ese jr $ra por li $v0, 10 y syscall (porque MARS arranca
# con $ra = 0x00000000 y no con un jal main), justo antes de finalizar el programa:
# $ra = 0x00000000 (recuperado de la pila tras ejecutar lw $ra, 0($sp)).
# PC apunta a la instrucción li $v0, 10 (0x00400030) y luego al syscall (0x00400034), 
# donde finaliza limpiamente la ejecución.

# 2. ¿Qué hubiera ocurrido si no se hubiese desapilado el contenido de $ra?
# Si se omitiera la instrucción lw $ra, 0($sp) antes del jr $ra de main:
# El registro $ra seguiría conteniendo la dirección 0x00400024, que fue la dirección de 
# retorno cargada cuando se ejecutó jal subr (es decir, apuntando a la instrucción 
# sw $v0, suma($0) dentro del propio main).   
# Al ejecutar jr $ra, en lugar de salir del programa, PC saltaría nuevamente a 0x00400024 
# (sw $v0, suma($0)).   
# El programa volvería a ejecutar el final de main y otra vez jr $ra, quedando atrapado en
# un bucle infinito (e incluso desajustando la pila si también se hubiera omitido el
# addi $sp, $sp, 4).