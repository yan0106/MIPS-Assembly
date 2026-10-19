# Algoritmo de Ordenamiento Burbuja (Bubble Sort) 
# para ordenar de forma ascendente (de menor a mayor) los elementos de la lista.
# contador: para n elementos, la cantidad máxima de pares a comparar es siempre n - 1
# sino, el último elemento, no tendría con quien compararse. 

.data # estas variables, como "size" que estan en el data, son variables globales.

size: .word 6

list: .word 6,5,1,20,2,40

.text

lw $t0, size   # define cuantas veces itero hasta terminar de ordenar la lista
addi $t0, $t0, -1 # contador interno ($t0) que empieza en la cantidad de elementos menos 1 (es decir, 6 - 1 = 5) y va decrementando
addi $t2, $t0, -1 # contador general, con -1 que $t0, es decir 5 - 1 = 4  
# En assembler, es mas optimo definir las iteraciones en decremento, 
# como hicimos aca, cosa que podamos cortar cuando comparemos el registro que contiene 
# el valor de las iteraciones y llegue a cero.

l2:
la $t1, list

l1:  # primer bucle, que contiene las 5 iteraciones
lw $t4, ($t1)
lw $t5, 4($t1)
blt $t4, $t5, noswp # si el 1ero. es < q el 2do., ya están en el orden correcto para quedar ascendentes, por lo q salta a noswp sin hacer nada
sw $t5, ($t1) # si el 1ero. es > o =, los intercambia de posición utilizando sw invertidas
sw $t4, 4($t1)

noswp:
addi $t1, $t1, 4 # se corre 4 bytes más para leer el elemento siguiente
addi $t0, $t0, -1 # decrementa el contador interno de iteraciones
beqz $t0, el1 # compara si el valor del registro llegó a cero
j l1

# esta sección es el puente de control entre las pasadas del ordenamiento burbuja. 
# ocurre justo cuando el bucle interno (l1) termina de recorrer la lista una vez.
# maneja dos contadores al mismo tiempo (el del bucle interno $t0 y el del bucle externo $t2)
# No termino de entender esta parte:
el1:
move $t0, $t2 # actualiza el contador interno ($t0) con el nuevo límite reducido en 1 de $t2
addi $t2, $t2, -1 # decrementa el contador general
beqz $t2, end # compara si el valor del registro es igual a 0.
j l2

end:
li $v0, 10
syscall