
.data	0x10000000
vector:		.word	0x10, 30, 0x34, 0x20, 60
		.align 2
maximo_vector:	.space	4	

.text
main:		# cargar los parámetros
		la $a0, vector
		li $a1, 5
		# llamar a la subrutina encontrar_maximo
		jal encontrar_maximo
		# guardar el resultado 
		la $t0, maximo_vector
		sw $v0, 0($t0)
		# salir del programa
		li $v0, 10
		syscall
	
# subrutina: encontrar_maximo
# propósito: iterar sobre los elementos de un vector para encontrar y devolver el valor máximo
# entrada: $a0 - dirección base del vector; $a1 - cantidad de elementos
# salida: $v0 - el valor máximo del vector
encontrar_maximo:	
# Como encontrar_maximo va a llamar internamente a otra función (max), 
# estamos obligados por las convenciones de MIPS a guardar en la memoria RAM
# (en la pila o Stack) los registros que vamos a usar, para que no se sobrescriban ni se pierdan.
		
		# --- PRÓLOGO ---
		addi $sp, $sp, -16	# Reserva 16 bytes en la pila (crece hacia abajo)
		sw $ra, 12($sp)	# Guarda la dirección de retorno en el tope
		sw $s0, 8($sp)	# Guarda $s0 original 
		sw $s1, 4($sp)	# Guarda $s1 original
		sw $s2, 0($sp)	# Guarda $s2 original
		# Este código se encarga de proteger la memoria antes de que la 
		# función empiece a hacer su trabajo principal.
		# Guarda el valor original que traía el registro $s0 en la RAM.
		# MIPS exige que si una función usa los registros $s, debe devolverlos
		# intactos al terminar. Los guardamos ahora para poder usarlos libremente.
		
		# Una vez que el prólogo terminó y blindó la memoria, la subrutina 
		# necesita asegurar los datos que recibió del main (la dirección del 
		# vector y la cantidad de elementos).
		# --- COPIA DE PARÁMETROS ---
		move $s0, $a0	# Protege la dirección del vector en $s0
		move $s1, $a1	# Protege la cantidad de elementos en $s1 (5)
		
		# --- INICIALIZACIÓN ---
		li $s2, 0		# $s2 guardará el máximo temporal. Lo inicializamos en 0.
loop: 		beqz $s1, fin_loop	# si $s1 (contador) llegó a cero, salta a fin_loop
		
		# --- PREPARAR PARÁMETROS Y LLAMAR A MAX ---
		move $a0, $s2	# Parámetro 1 ($a0): el máximo actual que tenemos guardado
		lw $a1, 0($s0)	# Parámetro 2 ($a1): el elemento del vector en esta iteración
		jal max		# Saltamos a la subrutina max. ¡Acá es donde el $ra se sobrescribe!
		
		move $s2, $v0	# La función max nos devuelve el ganador en $v0. Lo actualizamos en $s2.
		
		# --- AVANZAR AL SIGUIENTE ELEMENTO ---
		addi $s0, $s0, 4	# Movemos el puntero del vector 4 bytes (siguiente word)
		addi $s1, $s1, -1	# Le restamos 1 al contador de elementos
		j loop		# Volvemos a iterar
		
fin_loop:
		move $v0, $s2	# Movemos el resultado final a $v0 para que el main lo atrape
		
		# --- EPÍLOGO ---
		lw $s2, 0($sp)	# Restauramos el $s2 original desde el fondo de la pila
		lw $s1, 4($sp)	# Restauramos el $s1 original
		lw $s0, 8($sp)	# Restauramos el $s0 original
		lw $ra, 12($sp)	# Restauramos la dirección de retorno vital para volver al main
		addi $sp, $sp, 16	# Liberamos los 16 bytes de la pila (sumando, porque crece hacia abajo)
		
		jr $ra		# Retornamos el control al main
		
# subrutina: max
# propósito: devuelve el mayor de dos enteros
# entrada: $a0 - elemento 1; $a1 - elemento 2
# salida: $v0 - el elemento mayor
max:
		move $v0, $a0	# Asumimos primero que $a0 es el mayor
		bge $a0, $a1, fin_max # Si $a0 >= $a1, la suposición era correcta. Saltamos al final.
		move $v0, $a1	# Si no saltó, significa que $a1 era mayor. Sobrescribimos $v0.
fin_max:
		jr $ra		# Retornamos a encontrar_maximo
		
		
		
		
		
		
		