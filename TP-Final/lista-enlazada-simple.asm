.data
slist:   .word 0          # Puntero a la cabeza de la lista (inicializado a null)
numbers: .word 1, 2, 3    # Lista de enteros estática
numSize: .word 3          # Cantidad de números en la lista (para el bucle)

.text
.globl main
main:
    la $s0, numbers       # Carga la dirección base del arreglo estático en $s0
    lw $s1, numSize       # Carga la cantidad de iteraciones (3) en $s1

loop:
    lw $a0, 0($s0)        # Extrae el número actual del arreglo en $a0
    jal newnode           # Salta a la subrutina para agregarlo a la lista

    addi $s0, $s0, 4      # Avanza el puntero del arreglo a la siguiente palabra (4 bytes)
    addi $s1, $s1, -1     # Resta 1 al contador de iteraciones
    bnez $s1, loop        # Si el contador no es 0, vuelve a loop

    # Finalización limpia del programa
    li $v0, 10            # Servicio 10 de syscall (Exit)
    syscall

# -------------------------------------------------------------
# Subrutina: newnode
# Propósito: Crea un nuevo nodo (8 bytes) usando el Heap (sbrk)
#            y lo inserta al principio de la lista enlazada.
# Entrada:   $a0 - Contiene el valor entero a guardar en el nodo.
# Salida:    Ninguna (actualiza la variable global slist).
# -------------------------------------------------------------
newnode:
    move $t0, $a0         # Preserva el argumento (el número) en $t0
    
    # Solicitar memoria dinámica (sbrk)
    li $v0, 9             # Servicio 9 de syscall (sbrk)
    li $a0, 8             # Pide 8 bytes de memoria (4 para int, 4 para el puntero)
    syscall               # $v0 devuelve la dirección del bloque reservado

    sw $t0, 0($v0)        # Guarda el número en el primer campo del nuevo nodo

    la $t2, slist         # Carga la DIRECCIÓN de 'slist' en $t2 para poder actualizarla luego
    lw $t1, 0($t2)        # Carga el CONTENIDO (dirección del 1er nodo o null) en $t1
    
    beqz $t1, first       # Si la lista está vacía (null/0), salta a 'first'

    # Inserción al principio de una lista con elementos
    sw $t1, 4($v0)        # Conecta el nuevo nodo con la cabeza actual (campo puntero)
    sw $v0, 0($t2)        # Actualiza 'slist' para que apunte al nuevo nodo
    jr $ra                # Retorna a main

first:
    # Inserción en lista vacía
    sw $zero, 4($v0)      # El puntero al próximo nodo es null (0)
    sw $v0, 0($t2)        # 'slist' apunta al nuevo nodo
    jr $ra                # Retorna a main