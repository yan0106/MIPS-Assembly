# Hacer un programa en assembly de MIPS R2000, que solicite una cantidad de números y
# luego imprima los cuadrados de los mismos como se muestra en el ejemplo de ejecución.
# El programa debe terminar con un mensaje. Documente su programa de la mejor manera
# posible. Se asume que los números ingresados no darán overflow. Respete las cadenas
# de mensajes como se muestran en el ejemplo de ejecución a continuación:
# Introduzca una cantidad: 3
# Introduzca el elemento [1]: 4
# Introduzca el elemento [2]: 1
# Introduzca el elemento [3]: 5
# La lista de cuadrados es: 16 1 25
# Fin del programa
# Se provee un template básico que deberá seguir para la realización del código:

.data
msg1:	.asciiz "Introduzca una cantidad: "
msg2:	.asciiz "Introduzca el elemento ["
msg3:	.asciiz "]: "
msg4:	.asciiz "La lista de cuadrados es: "
msg5:	.asciiz "\nFin del programa"
	.align 2
# tamaño del vector
vecs:	.word 0
# dirección del vector dinámico
vecp:	.word 0

.text
main:
	# solicitar la cantidad de números
	la $a0, msg1
	li $v0, 4
	syscall	
	# leer entero ingresado por el usuario
	li $v0, 5
	syscall
	# validación
	blez $v0, fin
	# guardar la cantidad en el vector vecs
	sw $v0, vecs	
	# reservar memoria dinamica para la cantidad pedida
	mul $a0, $v0, 4		# multiplica la cant * 4 bytes
	li $v0, 9
	syscall
	# guardar la dirección del heap pedido en vecp
	sw $v0, vecp
	# preparar las variables del bucle
	lw $t0, vecs		# contador
	li $t1, 1		# índice
	lw $t2, vecp		# carga en $t2 el conenido de vecp (la dirección guardada del heap),
				# no la dirección de vecp	
loop1:	
	# solicitar los enteros y cargarlos en el vector
	# condición de corte del bucle
	beqz $t0, fin_loop1	# si el contador llegó a 0, salta a fin_loop1
	# imprimir msg2
	la $a0, msg2
	li $v0, 4
	syscall
	# copiar en $a0 el indice 	
	move $a0, $t1
	# imprimir el número del indice
	li $v0, 1
	syscall
	# imprimir msg3
	la $a0, msg3
	li $v0, 4
	syscall
	# leer el entero ingresado por el usuario
	li $v0, 5
	syscall
	# almacenarlo en la dirección de vecp
	sw $v0, 0($t2)
	# restar 1 al contador
	addi $t0, $t0, -1	
	# sumar 4 a la dirección del vector
	addi $t2, $t2, 4
	# sumar 1 al índice
	addi $t1, $t1, 1
	j loop1	
fin_loop1:
	# preparar los argumentos para la subrutina sqr
	lw $a0, vecs		# $a0: tamaño del vector
	lw $a1, vecp		# $a1: dirección de inicio del heap reservado
	# llamar a la función que calcula los cuadrados y los almacena 
	jal sqr
	
imprimir_lista:	
	# imprimir la lista
	lw $t0, vecp($0)
	lw $t1, vecs($0)
	la $a0, msg4
	li $v0, 4
	syscall
loop2:
	lw $a0, ($t0)
	li $v0, 1
	syscall
	li $a0, 0x20
	li $v0, 11
	syscall
	addi $t0, $t0, 4
	addi $t1, $t1, -1
	bnez $t1, loop2
	# imprimir mensaje de cierre
	la $a0, msg5
	li $v0, 4
	syscall		
fin:	
	# end
	li $v0, 10
	syscall

sqr: 
	# codigo funcion sqr
	# $a0: tamaño del vector
	# $a1: dirección de inicio del heap reservado
loop_sqr:
	beqz $a0, fin_sqr	# si $a0 llega a 0, salta a fin_sqr	
	lw $t0, 0($a1)		# carga en $t0 el contenido
	mul $t0, $t0, $t0	# $t0 * $t0
	sw $t0, 0($a1)		# sobreescribe en vecp
	add $a1, $a1, 4		# avanza el puntero
	addi $a0, $a0, -1	# resta 1 al tamaño del vector
	j loop_sqr
fin_sqr:
	jr $ra			# retorna a main
	