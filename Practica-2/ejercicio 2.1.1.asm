
.data
num1:	.word 0x7fffffff
num2: 	.word 16
	.space 8

.text
main: 	lw $s0, num1	# Carga el valor 0x7fffffff desde num1 al registro $s0
	lw $s1, num2	# Carga el valor 16 (0x10) desde num2 al registro $s1
	mult $s0, $s1	# Multiplica el contenido de $s0 (0x7fffffff) por el de $s1 (0x10)
	mfhi $s0		# Copia el contenido del registro hi (0x00000007) al registro $s0
	mflo $s1		# Copia el contenido del registro lo (0xfffffff0) al registro $s1
	sw $s0, num2+4	# Guarda el valor actual de $s0 (0x00000007) en la direcc. de memoria num2 + 4 bytes
	sw $s1, num2+8	# Guarda el valor actual de $s1 (0xfffffff0) en la direcc. de memoria num2 + 8 bytes
	
# mult: Esta instrucción no guarda el resultado en un registro $s o $t. 
# El resultado de 64 bits se almacena en dos registros especiales:
# hi: Contiene los 32 bits superiores (más significativos) del resultado.
# lo: Contiene los 32 bits inferiores (menos significativos) del resultado.
