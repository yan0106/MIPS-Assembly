# Identifica las instrucciones que se necesitan en:
# El programa que hace la llamada para:
# a) La carga de parámetros en los registros.
# b) La llamada a la subrutina.
# c) El almacenamiento del resultado.
# La subrutina para:
# a) La lectura y procesamiento de parámetros.
# b) La carga del resultado en $v0
# c) El retorno al programa que ha hecho la llamada.

.data
rango1:	.word 10
rango2:	.word 50
dato:	.word 12
res:	.space 1

.text
main:	addi $sp, $sp, -4
	sw $ra, 0($sp)		# apilar ra
	lw $a0, rango1($0)	# a0 = rango1
	lw $a1, rango2($0)	# a1 = rango2
	lw $a2, dato($0)	# a2 = dato
	jal subr		# saltar a subr
	sb $v0, res($0)		# res = v0
	lw $ra, 0($sp)
	addi $sp, $sp, 4		# desapilar ra
	li $v0, 10		# terminar la ejecución del programa
	syscall			
	
subr:	blt $a2, $a0, sino	# si a2 < a0 saltar a sino
	bgt $a2, $a1, sino	# si a2 > a1 saltar a sino

entonces:
	addi $v0, $0, 1		# v0 = 1
	j finsi			# saltar a finsi

sino:	add $v0, $0, $0		# v0 = 0

finsi:	jr $ra	 

# 1. En el programa que hace la llamada (main):
# a) La carga de parámetros en los registros:
# lw $a0, rango1($0)	
# lw $a1, rango2($0)	
# lw $a2, dato($0)
# b) La llamada a la subrutina:
# jal subr
# c) El almacenamiento del resultado:
# sb $v0, res($0)

# 2. En la subrutina (subr):
# a) La lectura y procesamiento de parámetros:
# blt $a2, $a0, sino	
# bgt $a2, $a1, sino
# b) La carga del resultado en $v0:
# addi $v0, $0, 1   
# o bien:
# add $v0, $0, $0
# c) El retorno al programa que ha hecho la llamada:
# jr $ra