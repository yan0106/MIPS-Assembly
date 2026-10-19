.data
number:	.word 0x12345678
.text
main: 	lw $s0, number  # no especifica un registro base.

# Esta forma es muy útil cuando la dirección de memoria del dato a buscar está bien definida
# con una etiqueta y no es dinámica, es decir, no cambia 