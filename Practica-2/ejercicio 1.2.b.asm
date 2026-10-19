
.data
number:	.word 0x12345678
.text
main: 	lw $s0, number($0)	

# $0 : es el registro $zero, contiene el valor 0.
# 1. La CPU calcula la dirección efectiva sumando el contenido del registro base ($0, que es 0)
# y el desplazamiento de la etiqueta number, que representa la dirección 0x10010000 (por defecto)
# 2. La dirección efectiva es 0 + dirección_de_number = dirección_de_number.
# 3. La instrucción lw va a esa dirección en la memoria (0x10010000) y lee la palabra (0x12345678).
# 4. Ese valor (0x12345678) se carga en el registro destino $s0.
