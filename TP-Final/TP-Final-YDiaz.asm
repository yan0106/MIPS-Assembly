#----------------------------------------------------------------------------
# Trabajo Práctico Final: Estructura de datos en assembly MIPS R2000
# Alumna: Yandira Diaz
# Materia: Arquitectura de las Computadoras I - AUS (IPS)
#----------------------------------------------------------------------------

.data
slist:	  .word 0	# Simple List: lista enlazada simple de bloques liberados
cclist:   .word 0	# Circular Category List: lista principal de categorias
wclist:   .word 0	# Working Category List: nodo de la categoria de trabajo actual
schedv:   .space 32	# Scheduler Vector (8 opciones x 4 bytes)
menu: 	  .ascii "Colecciones de objetos categorizados\n"
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
error: 	  .asciiz "Error: "
return:	  .asciiz "\n"
catName:  .asciiz "\nIngrese el nombre de una categoria: "
selCat:	  .asciiz "\nSe ha seleccionado la categoria: "
idObj:	  .asciiz "\nIngrese el ID del objeto a eliminar: "
objName:  .asciiz "\nIngrese el nombre de un objeto: "
success:  .asciiz "La operacion se realizo con exito\n\n"
notFound: .asciiz "notFound\n"

.text
main:	 
	# Inicializar el Vector Scheduler (schedv) 
    	la $t0, schedv		
    	la $t1, newcategory	# Opcion 1
    	sw $t1, 0($t0)
    	la $t1, nextcategory	# Opcion 2
    	sw $t1, 4($t0)
    	la $t1, prevcategory	# Opcion 3
    	sw $t1, 8($t0)
    	la $t1, listcategories	# Opcion 4
    	sw $t1, 12($t0)
    	la $t1, delcategory	# Opcion 5
    	sw $t1, 16($t0)
    	la $t1, newobject	# Opcion 6
    	sw $t1, 20($t0)
    	la $t1, listobjects	# Opcion 7
    	sw $t1, 24($t0)
    	la $t1, delobject	# Opcion 8
    	sw $t1, 28($t0)
    	
menu_loop:
	# Imprimir el menu de opciones
	li $v0, 4		
    	la $a0, menu		
    	syscall
    	
	# Leer la opcion del usuario
    	li $v0, 5		
    	syscall			
    	move $s0, $v0			# Guarda la opcion en $s0 de forma segura
	
	# Validar la entrada (0 = Salir, 1-8 = Ejecutar, Otro = Error)
    	beqz $s0, exit_program		# Si ingresa 0, salta a exit_program
    	bltz $s0, invalid_option	# Si es menor que 0, error
    	li $t1, 8
    	bgt $s0, $t1, invalid_option	# Si es mayor que 8, error

	# Calcular el desplazamiento y ejecutar la subrutina correspondiente	
    	addi $t1, $s0, -1	# Opcion 1 corresponde al indice 0
    	mul $t1, $t1, 4		# Desplazamiento en bytes = indice * 4
    	la $t0, schedv		# Direccion base del vector
    	add $t0, $t0, $t1	# Suma el desplazamiento
    	lw $t2, 0($t0)		# Carga en $t2 la direccion de la subrutina a ejecutar
	jalr $t2		# Salta a la subrutina y guarda el retorno en $ra
    
    	# Manejar el codigo de retorno devuelto por la subrutina
    	# $v0 == 0: exito | $v0 > 0: codigo de error | $v0 < 0: mensaje (ej: "notFound")
    	beqz $v0, success_msg	# Si $v0 es 0, salio bien
    	bltz $v0, menu_loop	# Si $v0 < 0, vuelve al menu
    	
    	move $a0, $v0		# Pasa el numero de error a $a0
    	jal print_error		
    	j menu_loop     	

success_msg:
    	li $v0, 4
    	la $a0, success
    	syscall
    	j menu_loop		
    	
invalid_option:
    	li $a0, 101		# Error 101: Seleccion inexistente
    	jal print_error
    	j menu_loop

# Subrutina: print_error
# Proposito: Imprime el codigo numerico de error en la consola
# Entrada: $a0 = el numero de error

print_error:
    	move $t0, $a0       	# Preserva el numero de error

    	li $v0, 4		
    	la $a0, error       	# Imprime "Error: "
    	syscall

    	li $v0, 1           	
    	move $a0, $t0       	# Imprime el numero de error
    	syscall

    	li $v0, 4		
    	la $a0, return		# Imprime un salto de linea
    	syscall

    	jr $ra
						
exit_program:
    	li $v0, 10		
    	syscall

# Subrutina: newcategory
# Proposito: Pide el nombre de una categoria y la añade al final de la lista (cclist).
# Si es la primera, la marca automaticamente como la categoria activa (wclist).
# Devuelve:  $v0 = 0 si tuvo exito.

newcategory:
    	# Preparar la pila (guardar el registro $ra)
    	addi $sp, $sp, -4	
    	sw $ra, 4($sp)          

    	# Pedir el nombre de la categoria al usuario
    	la $a0, catName         
    	jal getblock            # Pide memoria y guarda el string ingresado en el bloque
    	move $a2, $v0           # $a2 = puntero al string de la categoria

    	# Añadir el nodo a la lista de categorias (cclist)
    	la $a0, cclist          # $a0 = direccion de la lista de categorias
    	li $a1, 0               # $a1 = 0 (sublista de objetos al inicio vacia)
    	jal addnode             # Engancha el nuevo nodo al final de cclist

    	# Actualizar la categoria activa (wclist) si era la primera
    	lw $t0, wclist          
    	bnez $t0, newcategory_end # Si ya hay una categoria activa, no cambia wclist
    	sw $v0, wclist          # Si wclist era 0, apunta al nuevo nodo creado

newcategory_end:
    	# Retornar exito y limpiar la pila
    	li $v0, 0               
    	lw $ra, 4($sp)          
   	addi $sp, $sp, 4        
    	jr $ra                  
  
# Subrutina: nextcategory
# Proposito: Avanza la seleccion de la categoria activa (wclist) al siguiente nodo
# en la lista doble circular de categorias e imprime el nombre de la categoria seleccionada.
# Devuelve:  $v0 = 0 si tuvo exito, $v0 = 201 si no hay categorias,
# $v0 = 202 si hay una sola.

nextcategory:
    	lw $t0, wclist          # Carga el puntero a la categoria seleccionada actual
    	beqz $t0, error_201     # Si es 0 (no hay categorias), error 201

    	lw $t1, 12($t0)         # Carga el puntero al siguiente (offset 12)
    	beq $t0, $t1, error_202 # Si el siguiente es el mismo nodo (solo hay 1), error 202

    	sw $t1, wclist          # Actualiza wclist con el nuevo nodo seleccionado
    	j selcat_success        

# Subrutina: prevcategory
# Proposito: Retrocede la seleccion de la categoria activa (wclist) al nodo anterior
# en la lista doble circular de categorias e imprime el nombre de la categoria seleccionada.
# Devuelve:  $v0 = 0 si tuvo exito, $v0 = 201 si no hay categorias,
# $v0 = 202 si hay una sola.

prevcategory:
    	lw $t0, wclist          # Carga el puntero a la categoria actual
    	beqz $t0, error_201     # Si es 0 (no hay categorias), error 201

    	lw $t1, 0($t0)          # Carga el puntero al anterior (offset 0)
    	beq $t0, $t1, error_202 # Si el anterior es el mismo nodo (solo hay 1), error 202

    	sw $t1, wclist          # Actualiza wclist con el nuevo nodo
    	j selcat_success        

# Subrutinas auxiliares de seleccion
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
    	lw $a0, 8($t0)          # Puntero al string (nombre de la categoria en offset 8)
    	li $v0, 4
    	syscall
    
    	li $v0, 0               
    	jr $ra  

# Subrutina: listcategories
# Proposito: Recorre e imprime en consola la lista completa de categorias, 
# marcando con '>' unicamente a la categoria seleccionada en curso.
# Devuelve:  $v0 = 0 si tuvo exito, $v0 = 301 si no hay categorias.

listcategories:
    	lw $t0, cclist          # Carga el puntero inicial de la lista de categorias
    	beqz $t0, error_301     # Si la lista esta vacia (0), error 301

    	lw $t1, wclist          # Carga la direccion de la categoria en curso
    	move $t2, $t0           # Iterador: empieza en el primer nodo (cclist)

list_loop:
    	# Determinar si el nodo actual ($t2) es la categoria seleccionada ($t1)
    	bne $t2, $t1, print_space
    	li $a0, 62              # Caracter '>' (ASCII 62)
    	j print_char

print_space:
    	li $a0, 32              # Caracter ' ' (ASCII 32)

print_char:
    	li $v0, 11              
    	syscall

    	# Imprimir el nombre de la categoria actual (offset 8)
    	lw $a0, 8($t2)          
    	li $v0, 4               
    	syscall                 

    	# Avanzar al siguiente nodo en la lista (offset 12)
    	lw $t2, 12($t2)         

    	# Repetir hasta volver al inicio ($t0)
    	bne $t2, $t0, list_loop

    	li $v0, 0               
    	jr $ra

error_301:
    	li $v0, 301             # Error 301: No hay categorias creadas
    	jr $ra

# Subrutina: delcategory
# Proposito: Borra la categoria actualmente seleccionada (wclist).
# Si tiene objetos, libera primero todos sus nodos.
# Devuelve:  $v0 = 0 si tuvo exito, $v0 = 401 si no hay categorias.

delcategory:
	# Preservar registros en la pila ($ra y $s0)
    	addi $sp, $sp, -8
    	sw $ra, 8($sp)
    	sw $s0, 4($sp)
    	
    	# Verificar si hay categorias creadas
    	lw $s0, wclist          # $s0 = categoria actual a borrar
    	beqz $s0, error_401     # Si es 0, salta a error 401
    	
del_objects_loop:
    	# Revisar la sublista de objetos (offset 4 de la categoria)
    	lw $t0, 4($s0)          # $t0 = direccion del primer objeto de la sublista
    	beqz $t0, del_cat_node  # Si la lista de objetos esta vacia (0), borra la categoria
    	
    	# Borrar el primer objeto de la lista
    	move $a0, $t0           # $a0 = nodo del objeto a borrar
    	addi $a1, $s0, 4        # $a1 = direccion del puntero a la sublista de objetos
    	jal delnode             # Borra el objeto y libera la memoria con sfree
    	j del_objects_loop      # Repite hasta vaciar la sublista
    	
del_cat_node:
    	# Determinar cual sera la nueva categoria seleccionada (wclist)
    	lw $t1, 12($s0)         # $t1 = siguiente categoria (offset 12)
    	beq $t1, $s0, only_one_cat # Si la siguiente es ella misma, era la unica

    	sw $t1, wclist          # Si hay mas, wclist pasa a ser la siguiente
    	j execute_del_cat
    	
only_one_cat:
	sw $zero, wclist        # Pone en 0 (NULL) la categoria activa
    	sw $zero, cclist        # Pone en 0 (NULL) la cabeza de la lista principal
	
execute_del_cat:
    	# Borrar la categoria de la lista (cclist)
    	move $a0, $s0           # $a0 = nodo de la categoria a borrar
    	la $a1, cclist          # $a1 = direccion de la lista principal de categorias
    	jal delnode             # Borra la categoria y libera la memoria

    	# Salida exitosa
    	li $v0, 0               
    	j delcategory_exit
     
error_401:
    	li $v0, 401             # Error 401: No hay categorias para borrar

delcategory_exit:
    	# Restaurar la pila y volver
    	lw $s0, 4($sp)
    	lw $ra, 8($sp)
    	addi $sp, $sp, 8
    	jr $ra

# Subrutina: newobject
# Proposito: Pide el nombre de un objeto, calcula su ID local autoincremental
# (1 si la lista esta vacia, o ultimo ID + 1) y lo anexa a la sublista de la categoria
# en curso (wclist).
# Devuelve:  $v0 = 0 si tuvo exito, $v0 = 501 si no hay categoria seleccionada.

newobject:
    	# Reservar la pila
    	addi $sp, $sp, -8
    	sw $ra, 8($sp)
    	sw $s0, 4($sp)
    
   	# Verificar que exista una categoria activa
    	lw $s0, wclist          # $s0 = nodo de la categoria activa
    	beqz $s0, error_501     # Si no hay categoria seleccionada, error 501

	# Pedir el nombre del objeto
    	la $a0, objName         # Carga el mensaje "Ingrese el nombre de un objeto: "
    	jal getblock            # Asigna bloque y lee el string
    	move $a2, $v0           # $a2 = puntero al string ingresado
    	
    	# Calcular el ID local: 1 si la lista esta vacia, sino (ID del ultimo + 1)
    	lw $t0, 4($s0)          # $t0 = cabeza de la sublista de objetos
    	li $a1, 1               # ID por defecto = 1
    	beqz $t0, newobj_add    # Si la lista esta vacia, mantiene ID = 1

    	lw $t1, 0($t0)          # $t1 = ultimo nodo (el anterior de la cabeza en la lista circular)
    	lw $t2, 4($t1)          # $t2 = ID del ultimo objeto
    	addi $a1, $t2, 1        # $a1 = nuevo ID = ultimo ID + 1

newobj_add:
    	# Agregar el nodo a la sublista de objetos
    	addi $a0, $s0, 4        # $a0 = direccion de la sublista de objetos (offset 4 del nodo apuntado por wclist)
    	jal addnode             # Engancha el nodo ($a1 = ID, $a2 = string)

	# Retornar exito
    	li $v0, 0
    	j newobject_exit

error_501:
    	li $v0, 501             # Error 501: No hay categoria seleccionada

newobject_exit:
    	lw $s0, 4($sp)
    	lw $ra, 8($sp)
    	addi $sp, $sp, 8
    	jr $ra

# Subrutina: listobjects
# Proposito: Recorre e imprime la sublista de objetos de la categoria en 
# curso (wclist), mostrando su ID local y nombre.
# Devuelve:  $v0 = 0 si tuvo exito, $v0 = 601 si no hay categorias creadas, 
# $v0 = 602 si la categoria seleccionada no tiene objetos.

listobjects:
    	lw $t0, wclist          # Carga categoria activa
    	beqz $t0, error_601     # Si es 0, error 601

    	lw $t1, 4($t0)          # Carga cabeza de la sublista de objetos (offset 4)
    	beqz $t1, error_602     # Si es 0, la categoria no tiene objetos (error 602)

    	move $t2, $t1           # $t2 = Iterador

list_obj_loop:
    	# Imprimir el ID del objeto (campo 2, offset 4)
    	lw $a0, 4($t2)          # Carga el ID guardado en el nodo
    	li $v0, 1               
    	syscall

    	# Imprimir flecha " -> "
    	li $v0, 11
    	li $a0, 32              # Espacio ' '
    	syscall
    	li $a0, 45              # Guion '-'
    	syscall
    	li $a0, 62              # Flecha '>'
    	syscall
    	li $a0, 32              # Espacio ' '
   	syscall

    	# Imprimir el nombre del objeto (offset 8 del nodo)
    	lw $a0, 8($t2)
    	li $v0, 4               
    	syscall

    	# Avanzar al siguiente objeto (offset 12)
    	lw $t2, 12($t2)

    	# Condicion de fin: repetir si no se volvio a la cabeza
    	bne $t2, $t1, list_obj_loop

    	li $v0, 0               # Exito
    	jr $ra

error_601:
    	li $v0, 601
    	jr $ra
    	
error_602:
    	li $v0, 602
    	jr $ra

# Subrutina: delobject
# Proposito: Pide el ID de un objeto y lo elimina de la sublista de objetos 
# de la categoria activa, liberando la memoria del nodo.
# Devuelve:  $v0 = 0 si tuvo exito, $v0 = 701 si no hay categorias creadas,
# $v0 = -1 si no se encontro el ID (imprime "notFound").

delobject:
    	# Preservar pila
    	addi $sp, $sp, -12
    	sw $ra, 12($sp)
    	sw $s0, 8($sp)
    	sw $s1, 4($sp)

    	# Validar que exista una categoria activa
    	lw $s0, wclist          # $s0 = categoria activa
    	beqz $s0, error_701     # Si no hay categorias, error 701

    	# Pedir el ID del objeto a eliminar
    	li $v0, 4
    	la $a0, idObj
    	syscall
	
	# Leer el entero ingresado
   	li $v0, 5               
    	syscall
    	move $t0, $v0           # $t0 = ID ingresado por el usuario

    	# Verificar si la categoria tiene objetos
    	lw $s1, 4($s0)          # $s1 = primer objeto
    	beqz $s1, obj_not_found # Si la lista esta vacia, el ID no existe

    	# Buscar el objeto en la lista comparando su ID
    	move $t1, $s1           # $t1 = Iterador

find_obj_loop:
    	lw $t2, 4($t1)          # $t2 = ID del nodo actual (offset 4)
    	beq $t2, $t0, found_obj # Si coincide con el ID ingresado, lo encontró

    	lw $t1, 12($t1)         # Siguiente objeto (offset 12)
    	bne $t1, $s1, find_obj_loop # Si no volvio al inicio, sigue buscando

obj_not_found:
    	li $v0, 4
    	la $a0, notFound        # Imprime "notFound\n"
    	syscall
    	li $v0, -1              # Retorna < 0 para volver al menu sin imprimir exito ni error
    	j delobject_exit

found_obj:
    	# Borrar el nodo usando delnode
    	move $a0, $t1           # $a0 = direccion del nodo objeto a borrar
    	addi $a1, $s0, 4        # $a1 = direccion del puntero a la sublista de objetos
    	jal delnode             # Elimina y libera la memoria

    	li $v0, 0               # Exito
    	j delobject_exit

error_701:
    	li $v0, 701

delobject_exit:
    	lw $s1, 4($sp)
    	lw $s0, 8($sp)
    	lw $ra, 12($sp)
    	addi $sp, $sp, 12
    	jr $ra

# ---------------------Subrutinas Obligatorias del Anexo-----------------------------------------------------------
 
smalloc:
	lw $t0, slist		# Carga en $t0 la direccion del primer bloque de la lista de liberados.
    	beqz $t0, sbrk		# Si la lista esta vacia (0), salta a sbrk para pedir memoria nueva al S.O.
    	move $v0, $t0         	# Si hay un bloque libre, lo prepara en $v0 para devolverlo.
    	lw $t0, 12($t0)       	# Carga en $t0 el puntero al siguiente bloque en la lista de liberados.
    	sw $t0, slist         	# Actualiza la cabeza de la lista (slist) para que apunte a ese siguiente bloque.
    	jr $ra                	# Retorna a la funcion que lo llamo.

sbrk:
    	li $a0, 16            	# Tamaño del bloque fijo en 16 bytes (4 palabras).
    	li $v0, 9             	# Servicio 9 de syscall (sbrk) para pedir memoria al Heap.
    	syscall               	# El sistema devuelve la direccion del nuevo bloque en $v0.
    	jr $ra                	# Retorna a la funcion que lo llamo.

sfree:
	lw $t0, slist		# Carga en $t0 la direccion actual de la cabeza de la lista de liberados.
	sw $t0, 12($a0)       	# El campo 'next' (offset 12) del bloque a liberar ahora apunta a la cabeza actual.
    	sw $a0, slist         	# Actualiza slist para que el bloque recien liberado ($a0) sea la nueva cabeza.
    	jr $ra                	# Retorna a la funcion que lo llamo.

# a0 = list address
# a1 = NULL if category, ID if object
# v0 = node address added

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

# a0 = node address to delete
# a1 = list address where node is deleted
	
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
	
# a0 = msg to ask
# v0 = block address allocated with string

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
