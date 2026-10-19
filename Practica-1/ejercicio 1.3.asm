
.data
cadena: .ascii "cadena" # Guarda el string en Data Segment pero no agrega NULL al final
octeto: .byte 0xff # Lo guarda en el byte contiguo

# En el Data Segment, se ven los valores ASCII en hexadecimal
# La instrucción .asciiz agrega el terminador NULL '00' 
