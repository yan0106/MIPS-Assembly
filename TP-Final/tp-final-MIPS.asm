.data
slist:	 .word 0
cclist:  .word 0
wclist:  .word 0
schedv:  .space 32
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
    	  	
# Stubs (etiquetas vacías para compilar el menú)
# Todas devuelven 0 en $v0 por defecto (éxito) y retornan.

nextcategory:
    li $v0, 0
    jr $ra

prevcategory:
    li $v0, 0
    jr $ra

listcategories:
    li $v0, 0
    jr $ra

delcategory:
    li $v0, 0
    jr $ra

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
newcaterogy:
    	addi $sp, $sp, -4	# Reserva 4 bytes en la pila (stack)
    	sw $ra, 4($sp)          # Guarda el registro de retorno ($ra) en la pila

    	la $a0, catName         # Carga en $a0 la dirección del mensaje "Ingrese el nombre..."
    	jal getblock            # Llama a getblock: pide memoria y guarda el string ingresado

    	move $a2, $v0           # $a2 = puntero al string con el nombre de la nueva categoría
    	la $a0, cclist          # $a0 = dirección de la lista principal de categorías (cclist)
    	li $a1, 0               # $a1 = NULL (0). Le avisa a addnode que es una categoría, no un objeto
    	jal addnode             # Llama a addnode para crear y enlazar el nuevo nodo en la lista

    	lw $t0, wclist          # Carga en $t0 el puntero a la categoría seleccionada actualmente
    	bnez $t0, newcategory_end # Si ya hay una categoría seleccionada (no es 0), salta al final
    	sw $v0, wclist          # Actualiza la lista de trabajo (wclist) apuntándola a esta nueva categoría

newcategory_end:
    	li $v0, 0               # Carga un 0 en $v0 para indicar que la operación fue un éxito (código de retorno)
    	lw $ra, 4($sp)          # Restaura el registro de retorno ($ra) original desde la pila
    	addi $sp, $sp, 4	# Libera los 4 bytes de la pila (pop)
    	jr $ra                  # Retorna a la función principal (al menú)

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
