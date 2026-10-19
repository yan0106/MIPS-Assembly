
.data 0x10000000			# Comienza en la dirección 0x10000000
enteros: 	.word 10,20,25,500,3		# vector de enteros (5 * 4 = 20 bytes)

.text
main: 	lw $s0, enteros		# Carga el 1° elemento del vector en el registro $s0 , 10
	la $t1, enteros		# Carga la dirección base del vector en el registro $t1
	lw $s1, 4($t1)		# En el registro $s1, carga el valor de 4+(Direcc. base) , 20
	lw $s2, 8($t1)		# Carga el valor 25
	lw $s3, 12($t1)		# Carga el valor 500
	lw $s4, 16($t1)		# Carga el valor 3
				# LOS VALORES SON CARGADOS EN HEXA en los registros
	li $t2, 0x10010000		# Carga en el registro $t2, 0x10010000
	sw $s0, 0($t2)		# Guarda el valor de $s0 en 0($t2) = 0x10010000
	sw $s1, 4($t2)		# Guarda el valor de $s1 en 4($t2) = 0x10010004
	sw $s2, 8($t2)		# Guarda el valor de $s2 en 8($t2) = 0x10010008
	sw $s3, 12($t2)		# Guarda el valor de $s3 en 12($t2) = 0x1001000C
	sw $s4, 16($t2)		# Guarda el valor de $s4 en 16($t2) = 0x10010010 (por acarreo)