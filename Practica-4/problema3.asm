# Implementa una subrutina en ensamblador, tal que dada una matriz de
# enteros de dimensión n x m, almacenada por filas, obtenga el elemento (i,j)
# de dicha matriz. La subrutina tendrá como parámetros de entrada: la
# dirección de la matriz, las dimensiones de la misma y los índices del
# elemento a devolver. La subrutina devolverá el elemento (i,j). Realiza la
# llamada y el retorno a la subrutina según el convenio establecido.

.data
# matriz 2X3 (2 filas, 3 columnas)
Fila0:	.word 10, 20, 30	# dirección base de la matriz, ya que el resto de las filas son contiguas
Fila1:	.word 40, 50, 60
res:	.space 4		# para guardar el resultado que devuelve

.text
main:	la $a0, Fila0		# dirección de la matriz, por referencia
	li $a1, 2		# dimensión n: filas
	li $a2, 3		# dimensión m: columnas
	li $a3, 1		# indice i (filas): 1
	li $t0, 2		# indice j (columna): 2
	addi $sp, $sp, -4	# reservo memoria para el 5° argumento, ya no puedo pasar más de 4 por registros
	sw $t0, 0($sp)		# guarda el contenido de $t0 (indice j) en la pila
	jal buscador
	
fin:	sw $v0, res
	addi $sp, $sp, 4	# libero la memoria de la pila
	li $v0, 10
	syscall 

# no necesita recorrer con un bucle, solo calcular las direcciones:	
buscador:
	lw $t0, 0($sp)			#  lee j desde 0($sp) de la pila
			
	# validar rangos
	bltz $a3, fuera_rango		# si i (filas) < 0
	bge $a3, $a1, fuera_rango	# si i >= n ($a1)
	bltz $t0, fuera_rango		# si j (columnas) < 0
	bge $t0, $a2, fuera_rango	# si j >= m ($a2)
	
	# calcular la dirección exacta: dir = baseDir + (i x m + j) x 4
	# i x m
	mul $t1, $a3, $a2
	# + j
	add $t1, $t1, $t0
	# x 4
	mul $t1, $t1, 4
	# + baseDir
	add $a0, $a0, $t1
	
	# retornar el valor
	lw $v0, ($a0)
	jr $ra
	
fuera_rango:
	li $v0, -1
	jr $ra

	
		
	
	
	
	  
	
	
	