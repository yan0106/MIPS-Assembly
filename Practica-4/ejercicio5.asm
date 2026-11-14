# Reinicializa el simulador, carga el programa y ejecútalo paso a paso
# ¿Cuál es el contenido del PC y del registro $ra antes y después
# de ejecutar la instrucción jal main?

.text

main:
	li $a0, 10
	li $a1, 20
	add $v1, $a0, $a1
	
	li $v0, 10      # Equivalente en MARS al jr $ra de XSPIM
    	syscall

# Como MARS 4.5 no inserta el código de arranque de XSPIM (jal main), esta 
# pregunta se responde según la teoría del enunciado:

# Antes de ejecutar jal main:
# PC (Program Counter): Contiene la dirección de memoria 
# donde está almacenada la propia instrucción jal main (la próxima instrucción a ejecutarse).
# Aparentemente es: 0x00400000   
# $ra (Return Address): Contiene 0x00000000 (aún no se realizó ningún salto con enlace).

# Después de ejecutar jal main:
# PC: Pasa a contener la dirección de memoria de la primera instrucción de main 
#(por ejemplo, 0x00400024), transfiriendo allí el flujo del programa.
# $ra: Guarda automáticamente la dirección de la instrucción inmediatamente siguiente a
# jal main en el código del simulador (es decir, dirección_de_jal + 4), que es adonde 
# deberá volver cuando main termine.

   
         
