# 1.a) Subprograma NOR: toma dos parámetros de entrada y devuelve  la operación NOR sobre
# esos dos parámetros.

.data
msje:	.asciiz "Por favor, introduce un entero: "
entrada:	.asciiz "Introdujiste: "
res:	.asciiz "El resultado es: "

.text
main:		# leer el 1er. valor de entrada del usuario
		la $a0, msje
		jal TareaInt
		move $s0, $v0
		
		# imprimir el 1er. valor de vuelta al usuario
		jal NuevaLinea
		la $a0, entrada
		move $a1, $s0
		jal ImprimirValor
		move $s0, $a1
		
		# leer el 2do. valor de entrada del usuario
		jal NuevaLinea
		la $a0, msje
		jal TareaInt
		move $s1, $v0
		
		# imprimir el 2do. valor de vuelta al usuario
		jal NuevaLinea
		la $a0, entrada
		move $a1, $s1
		jal ImprimirValor
		move $s1, $a1
		
		# operación NOR
		move $a0, $s0
		move $a1, $s1
		jal OperacionNOR
		
		# imprimir el resultado final
		move $s0, $v0
		jal NuevaLinea
		la $a0, res
		move $a1, $s0
		jal ImprimirValor
				
		# salir del programa
		li $v0, 10
		syscall

# subrutina: TareaInt
# proposito: imprimirle al usuario un mensaje para que ingrese un entero y devolver ese entero
# entrada: $a0 - la dirección de la cadena a imprimir
# devuelve: $v0 - el valor ingresado por el usuario
# efecto secundario: la cadena se imprime siguida del valor entero ?
.text
TareaInt:		# imprime el mensaje que ya está en $a0
		li $v0, 4		# 4: Print_String ($a0)
		syscall
		# lee el entero
    		li $v0, 5		# 5: Read_Int (lo devuelve en $v0)
    		syscall
    		# el entero quedó automáticamente en $v0 como valor de retorno
    		jr $ra

# subrutina: NuevaLinea
# proposito: imprimir una nueva linea en la consola
# entrada: ninguna
# devuelve: ninguno
# efecto: imprime un nuevo carácter de salto de línea en la consola del usuario
.text
NuevaLinea:	li $v0, 4		# 4: Print_String ($a0)
		la $a0, _NL_	# guarda la dirección de _NL_ en el registro de arg $a0
		syscall
		jr $ra
.data
_NL_:	.asciiz "\n"

# subrutina: ImprimirValor
# proposito: imprimir el valor ingresado por el usuario
# entrada: $a0 - dirección del mensaje a mostrar
# salida: ninguno
# efecto: se imprime el mensaje, seguido del valor del entero ingresado por el usuario
.text
ImprimirValor:	li $v0, 4		# 4: Print_String ($a0)
		syscall
		li $v0, 1		# 1: Print_Int ($a0)
		move $a0, $a1	# valor de $s0 que pasó a $a1, lo paso a $a0 para syscall
		syscall
		jr $ra
		
# subrutina: OperacionNOR
# propósito: realizar la operación NOR sobre los dos parámetros ingresados por el usaurio
# y retornar el valor.
# entrada: $a0, $a1 - valores para operar
# salida:	$v0 - resultado de la operación 
.text
OperacionNOR:	nor $v0, $a0, $a1
		jr $ra
		
