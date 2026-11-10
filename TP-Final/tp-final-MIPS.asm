.data
slist:	 .word 0		# Simple List o lista enlazada simple de bloques liberados
cclist:  .word 0		# Circular Category List o lista principal de categorías
wclist:  .word 0		# Working Category List o lista/nodo de la categoría de trabajo actual
schedv:  .space 32		# Scheduler Vector
menu: 	 .ascii "Colecciones de objetos categorizados\n"
	 .ascii "====================================\n"
	 .ascii "1-Nueva categoria\n"
	 .ascii "2-Siguiente categoria\n"
	 .ascii "3-Categoria anterior\n"
	 .ascii "4-Listar categorias\n"
	 .ascii "5-Borrar categoria actual\n"
	 .ascii "6-Anexar objeto a la categoria actual\n"
	 .ascii "7-Listar objetos de la categoria\n"
	 .ascii "8-Borrar objeto de la categoria\n"
	 .ascii "0-Salir\n"
	 .asciiz "Ingrese la opcion deseada: "
error: 	 .asciiz "Error: "
return:	 .asciiz "\n"
catName: .asciiz "\nIngrese el nombre de una categoria: "
selCat:	 .asciiz "\nSe ha seleccionado la categoria:"
idObj:	 .asciiz "\nIngrese el ID del objeto a eliminar: "
objName: .asciiz "\nIngrese el nombre de un objeto: "
success: .asciiz "La operación se realizo con exito\n\n"

.text
main:	 
	# 1. Inicializar el Vector Scheduler (schedv) 
    	la $t0, schedv		# Carga la dirección base del vector    
    	la $t1, newcaterogy	# Opción 1
    	sw $t1, 0($t0)
    	la $t1, nextcategory	# Opción 2
    	sw $t1, 4($t0)
    	la $t1, prevcategory	# Opción 3
    	sw $t1, 8($t0)
    	la $t1, listcategories	# Opción 4
    	sw $t1, 12($t0)
    	la $t1, delcategory	# Opción 5
    	sw $t1, 16($t0)
    	la $t1, newobject	# Opción 6
    	sw $t1, 20($t0)
    	la $t1, listobjects	# Opción 7
    	sw $t1, 24($t0)
    	la $t1, delobject	# Opción 8
    	sw $t1, 28($t0)
    	
menu_loop:
	# 2. Imprimir el menú de opciones
	li $v0, 4		# Syscall 4: Print String
    	la $a0, menu		# Carga la dirección del texto del menú
    	syscall
    	
	# 3. Leer la opción del usuario
    	li $v0, 5		# Syscall 5: Read Integer
    	syscall			# El número ingresado queda guardado en $v0
    	move $s0, $v0		# Guarda la opción en $s0 de forma segura
	
	# 4. Validar la entrada (0 = Salir, 1-8 = Ejecutar, Otro = Error)
    	beqz $s0, exit_program		# Si ingresó 0, salta al fin del programa
    	bltz $s0, invalid_option	# Si es menor que 0, error
    	li $t1, 8
    	bgt $s0, $t1, invalid_option	# Si es mayor que 8, error

	# 5. Calcular desplazamiento y ejecutar la subrutina	
	# Como la opción 1 está en la posición 0, le resto 1 a la opción
    	addi $t1, $s0, -1
    	# Multiplico por 4 para obtener el byte exacto en la memoria
    	sll $t1, $t1, 2		# Shift Left Logical por 2 es igual a multiplicar por 4
    	# Buscar la dirección en el vector
    	la $t0, schedv		# Dirección base del vector
    	add $t0, $t0, $t1	# Suma el desplazamiento
    	lw $t2, 0($t0)		# Carga en $t2 la dirección de la subrutina a ejecutar
	jalr $t2		# Salta a la dirección contenida en $t2 y guarda el retorno
    
    	# 6. Manejar el código de error devuelto por la subrutina
    	# Las funciones devuelven 0 en $v0 si hay éxito, o un código > 0 si hay error.
    	beqz $v0, success_msg	# Si $v0 es 0, salió bien
    	# Si no es 0, imprimir el código de error
    	move $a0, $v0		# Pasa el número de error a $a0
    	jal print_error		# Llama a la subrutina para imprimir "Error: XXX"
    	j menu_loop     	# Vuelve al menú

success_msg:
    	li $v0, 4
    	la $a0, success
    	syscall
    	j menu_loop		# Vuelve al inicio del bucle
    	
    	# Excepciones del flujo principal
invalid_option:
    	li $a0, 101		# Error 101: Selección inexistente
    	jal print_error
    	j menu_loop

# Subrutina: print_error
# Entrada: $a0 contiene el número de error (ej: 101, 201)
print_error:
    	# 1. Asegurar el número. 
    	# Como syscall 4 va a sobrescribir $a0 con la dirección del texto, 
    	# se guarda el número del error en un temporal ($t0) para no perderlo.
    	move $t0, $a0       

    	# 2. Imprimir el texto "Error: "
    	li $v0, 4		# Servicio 4: Imprimir string
    	la $a0, error       	# Carga la dirección de la palabra "Error: "
    	syscall

    	# 3. Imprimir el número del error
    	li $v0, 1           	# Servicio 1: Imprimir entero
    	move $a0, $t0       	# Recupera el número desde $t0 hacia $a0
    	syscall

    	# 4. Imprimir un salto de línea en consola
    	li $v0, 4		# Servicio 4: Imprimir string
    	la $a0, return		# Carga la dirección del "\n" (declarado en .data)
    	syscall

    	# 5. Retornar al menú
    	jr $ra
						
exit_program:
    	li $v0, 10		# Syscall 10: Exit program
    	syscall

# Subrutina: newcategory
# Propósito: Crea una nueva categoría y la añade a la lista de categorías.
newcaterogy:
    	# 1. Preparar la pila (guardar el registro $ra)
    	addi $sp, $sp, -4	# Reserva 4 bytes en la pila
    	sw $ra, 4($sp)          # Guarda el registro de retorno ($ra)

    	# 2. Pedir el nombre de la categoría al usuario
    	la $a0, catName         # Carga en $a0 la dirección del texto "Ingrese el nombre..."
    	jal getblock            # Llama a getblock: pide memoria y guarda el string ingresado en el bloque
    	move $a2, $v0           # Mueve el puntero del nuevo string (que devolvió getblock) al registro $a2

    	# 3. Añadir el nodo a la lista de categorías (cclist)
    	la $a0, cclist          # Carga en $a0 la dirección de la lista de categorías
    	li $a1, 0               # $a1 = NULL (0). Indica que es un nodo de categoría (su lista interna de objetos está vacía)
    	jal addnode             # Llama a addnode para enganchar este nuevo bloque en la lista

    	# 4. Actualizar la categoría activa (wclist) si era la primera
    	lw $t0, wclist          # Carga en $t0 el puntero actual de la categoría de trabajo
    	bnez $t0, newcategory_end # Si ya hay una categoría activa (wclist != 0), salta al final
    	sw $v0, wclist          # Si wclist era 0, la actualizamos para que apunte al nodo recién creado (en $v0)

newcategory_end:
    	# 5. Retornar éxito y limpiar la pila
    	li $v0, 0               # Carga 0 en $v0 para indicar que la operación fue un éxito
    	lw $ra, 4($sp)          # Restaura el registro de retorno original ($ra) desde la pila
   	addi $sp, $sp, 4        # Libera el espacio de la pila (4 bytes)
    	jr $ra                  # Retorna al menú principal  
  
# Subrutina: nextcategory
nextcategory:
    	lw $t0, wclist          # Carga el puntero a la categoría seleccionada actual
    	beqz $t0, error_201     # Si es 0 (no hay categorías), error 201

    	lw $t1, 12($t0)         # Carga en $t1 el puntero al sucesor (next), ubicado en el offset 12
    	beq $t0, $t1, error_202 # Si el sucesor es el mismo nodo (hay solo 1), error 202

    	sw $t1, wclist          # Actualiza wclist con el nuevo nodo seleccionado
    	j selcat_success        # Salta a imprimir mensaje de éxito

# Subrutina: prevcategory
prevcategory:
    	lw $t0, wclist          # Carga el puntero a la categoría actual
    	beqz $t0, error_201     # Si es 0 (no hay categorías), error 201

    	lw $t1, 0($t0)          # Carga en $t1 el puntero al antecesor (prev), ubicado en el offset 0
    	beq $t0, $t1, error_202 # Si el antecesor es el mismo nodo (hay solo 1), error 202

    	sw $t1, wclist          # Actualiza wclist con el nuevo nodo
    	j selcat_success        

# Subrutinas auxiliares
error_201:
    	li $v0, 201
    	jr $ra
error_202:
    	li $v0, 202
    	jr $ra

selcat_success:
    	li $v0, 4
    	la $a0, selCat
    	syscall
    
    	lw $t0, wclist          
    	lw $a0, 8($t0)          # Puntero al string (nombre de la categoría en el offset 8)
    	li $v0, 4
    	syscall
    
    	li $v0, 0               
    	jr $ra  

# Subrutina: listcategories
# Propósito: Recorre e imprime todas las categorías de la lista circular,
# marcando la categoría en curso con '>'.
# Devuelve:  $v0 = 0 si tuvo éxito, $v0 = 301 si no hay categorías.
listcategories:
    	lw $t0, cclist          # Carga el puntero inicial de la lista de categorías
    	beqz $t0, error_301     # Si la lista está vacía (0), salta a devolver error 301

    	lw $t1, wclist          # Carga la dirección de la categoría en curso (seleccionada)
    	move $t2, $t0           # Puntero iterador: empieza en el primer nodo (cclist)

list_loop:
    	# 1. Determina si el nodo actual ($t2) es la categoría seleccionada ($t1)
    	bne $t2, $t1, print_space
    
    	# Imprime el selector '>' (código ASCII 62)
    	li $a0, 62              
    	j print_char

print_space:
    	# Imprime un espacio ' ' (código ASCII 32)
    	li $a0, 32              

print_char:
    	li $v0, 11              # Syscall 11: Print Character
    	syscall

    	# 2. Imprime el nombre de la categoría actual
    	# Recordatorio: el nombre/string está en el desplazamiento 8 ($t2 + 8)
    	lw $a0, 8($t2)          # Carga la dirección del string guardado en el nodo
    	li $v0, 4               # Syscall 4: Print String
    	syscall                 # Imprime el nombre (getblock ya incluye el \n)

    	# 3. Avanza al siguiente nodo en la lista circular
    	lw $t2, 12($t2)         # Carga el puntero al sucesor (offset 12)

    	# 4. Condición de parada: si no volvimos al inicio ($t0), continúa el bucle
    	bne $t2, $t0, list_loop

    	# Si completamos la vuelta, retorna éxito
    	li $v0, 0               # Cero indica éxito
    	jr $ra

error_301:
    	li $v0, 301             # Error 301: No hay categorías creadas
    	jr $ra

# Subrutina: delcategory
# Propósito: Borra la categoría actualmente seleccionada (wclist).
# Si tiene objetos vinculados, libera primero todos sus nodos.
# Devuelve:  $v0 = 0 si tuvo éxito, $v0 = 401 si no hay categorías.

delcategory:
	# 1. Preservar registros en la pila ($ra y los $s que usemos)
    	addi $sp, $sp, -12
    	sw $ra, 12($sp)
    	sw $s0, 8($sp)
    	sw $s1, 4($sp)
    	
    	# 2. Verificar si hay categorías creadas
    	lw $s0, wclist          # $s0 = categoría actual a borrar
    	beqz $s0, error_401     # Si es NULL/0, salta a error 401
    	
del_objects_loop:
    	# 3. Revisar la sublista de objetos (ubicada en offset 4 de la categoría)
    	lw $t0, 4($s0)          # $t0 = dirección del primer objeto de la sublista
    	beqz $t0, del_cat_node  # Si la lista de objetos está vacía (0), va a borrar la categoría
    	
    	# Borrar el primer objeto de la lista circular de objetos
    	move $a0, $t0           # Argumento 1: Nodo del objeto a borrar
    	addi $a1, $s0, 4        # Argumento 2: Dirección del puntero a la lista de objetos
    	jal delnode             # Borra el objeto y libera su memoria con sfree
    	j del_objects_loop      # Repite hasta que la sublista quede en 0
    	
del_cat_node:
    	# 4. Determinar cuál será la nueva categoría seleccionada (wclist)
    	lw $t1, 12($s0)         # $t1 = Siguiente categoría (offset 12)
    	beq $t1, $s0, only_one_cat # Si la siguiente es ella misma, era la única que había

    	sw $t1, wclist          # Si hay más, wclist pasa a ser la siguiente
    	j execute_del_cat
    	
only_one_cat:
	sw $zero, wclist        # Nulifica la categoría activa
    	sw $zero, cclist        # Nulifica la cabeza de la lista principal
	
execute_del_cat:
    	# 5. Borrar la categoría de la lista cclist
    	move $a0, $s0           # Argumento 1: Nodo de la categoría a borrar
    	la $a1, cclist          # Argumento 2: Dirección de la lista principal de categorías
    	jal delnode             # Borra la categoría y libera su bloque de memoria

    	# 6. Salida exitosa
    	li $v0, 0               # Éxito (0)
    	j delcategory_exit
     
error_401:
    	li $v0, 401             # Error 401: No hay categorías para borrar

delcategory_exit:
    	# 7. Restaurar pila y retornar
    	lw $s1, 4($sp)
    	lw $s0, 8($sp)
    	lw $ra, 12($sp)
    	addi $sp, $sp, 12
    	jr $ra

# ----------------------------------------------------------------------  	  	  	  		  	  	  	  	  	  	  		  	  	  	
# Stubs (etiquetas vacías para compilar el menú)
# Todas devuelven 0 en $v0 por defecto (éxito) y retornan.

newobject:
    	li $v0, 0
    	jr $ra

listobjects:
    	li $v0, 0
    	jr $ra

delobject:
    	li $v0, 0
    	jr $ra

# ----------------------------------------------------------------------
# node* smalloc() 
smalloc:
	lw $t0, slist		# Carga en $t0 la dirección del primer bloque de la lista de liberados.
    	beqz $t0, sbrk		# Si la lista está vacía (es null/0), salta a 'sbrk' para pedir memoria nueva al S.O.
    	move $v0, $t0         	# Si hay un bloque libre, lo prepara en $v0 para devolverlo.
    	lw $t0, 12($t0)       	# Carga en $t0 el puntero al SIGUIENTE bloque en la lista de liberados.
    	sw $t0, slist         	# Actualiza la cabeza de la lista ('slist') para que apunte a ese siguiente bloque.
    	jr $ra                	# Retorna a la función que lo llamó.

sbrk:
    	li $a0, 16            	# Tamaño del bloque fijado en 16 bytes (4 palabras).
    	li $v0, 9             	# Servicio 9 de syscall (sbrk) para pedir memoria al Heap.
    	syscall               	# El sistema devuelve la dirección del nuevo bloque en $v0.
    	jr $ra                	# Retorna a la función que lo llamó.

# void sfree(node* $a0)
sfree:
	lw $t0, slist		# Carga en $t0 la dirección actual de la cabeza de la lista de liberados.
	sw $t0, 12($a0)       	# El campo 'next' (offset 12) del bloque a liberar ahora apunta a la cabeza actual.
    	sw $a0, slist         	# Actualiza 'slist' para que el bloque recién liberado ($a0) sea la nueva cabeza (lista de "no usados").
    	jr $ra                	# Retorna a la función que lo llamó.

# ------------------ Anexos -------------------------------------------------------------

# a0: list address
# a1: NULL if category, node address if object
# v0: node address added
addnode:
	addi $sp, $sp, -8
	sw $ra, 8($sp)
	sw $a0, 4($sp)
	jal smalloc
	sw $a1, 4($v0) 		# set node content
	sw $a2, 8($v0)
	lw $a0, 4($sp)
	lw $t0, ($a0) 		# first node address
	beqz $t0, addnode_empty_list
	
addnode_to_end:
	lw $t1, ($t0) 		# last node address
	# update prev and next pointers of new node
	sw $t1, 0($v0)
	sw $t0, 12($v0)
	# update prev and first node to new node
	sw $v0, 12($t1)
	sw $v0, 0($t0)
	j addnode_exit
	
addnode_empty_list:
	sw $v0, ($a0)
	sw $v0, 0($v0)
	sw $v0, 12($v0)
	
addnode_exit:
	lw $ra, 8($sp)
	addi $sp, $sp, 8
	jr $ra
	# a0: node address to delete
	# a1: list address where node is deleted
	
delnode:
	addi $sp, $sp, -8
	sw $ra, 8($sp)
	sw $a0, 4($sp)
	lw $a0, 8($a0) 		# get block address
	jal sfree 		# free block
	lw $a0, 4($sp) 		# restore argument a0
	lw $t0, 12($a0) 	# get address to next node of a0 node
	beq $a0, $t0, delnode_point_self
	lw $t1, 0($a0) 		# get address to prev node
	sw $t1, 0($t0)
	sw $t0, 12($t1)
	lw $t1, 0($a1) 		# get address to first node again
	bne $a0, $t1, delnode_exit
	sw $t0, ($a1) 		# list point to next node
	j delnode_exit
	
delnode_point_self:
	sw $zero, ($a1) 	# only one node
	
delnode_exit:
	jal sfree
	lw $ra, 8($sp)
	addi $sp, $sp, 8
	jr $ra
	
# a0: msg to ask
# v0: block address allocated with string
getblock:
	addi $sp, $sp, -4
	sw $ra, 4($sp)
	li $v0, 4
	syscall
	jal smalloc
	move $a0, $v0
	li $a1, 16
	li $v0, 8
	syscall
	move $v0, $a0
	lw $ra, 4($sp)
	addi $sp, $sp, 4
	jr $ra
