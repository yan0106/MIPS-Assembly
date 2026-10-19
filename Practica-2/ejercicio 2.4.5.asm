
.data	  0x10000000
numero:     .word 0x1237    	# (Ocupa 0x10000000 - 0x10000003)
resultado:  .space 4       	# (Ocupa 0x10000004 - 0x10000007)

.text
main:
        lw $s0, numero      	# Carga 0x1237 en $s0
        sll $s1, $s0, 5     	# Desplaza $s0 5 bits a la izquierda (multiplica por 32), resultado en $s1
        la $t0, resultado   	# Carga la dirección de 'resultado' en $t0
        sw $s1, 0($t0)	# Guarda el resultado ($s1) en la dirección contenida en $t0