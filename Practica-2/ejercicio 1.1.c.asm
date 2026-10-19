
.data
number: .word 0x12345678 
.text
main: la $s0, number 

# la (load address) pseudoinstrucción para cargar direcciones de memoria en un registro.
# ejecuta las intrucciones reales: lui $at 0x1001 y ori $s0, $at 0x0000
# Dsps de ejecutar las dos instrucciones reales, el registro $s0 debería contener
# la dirección de memoria donde está almacenado number 0x10010000.