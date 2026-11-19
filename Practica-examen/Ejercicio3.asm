# Introducción:
# En matemática, una serie geométrica simple basada en potencias consiste en sumar
# los resultados de elevar una misma base a exponentes consecutivos. Por ejemplo, si
# la base es 2 y el exponente máximo es 3, la sumatoria es: 2^1 + 2^2 + 2^3 = 2 + 4 + 8 = 14.

# Consigna:
# Hacer un programa en assembly de MIPS R2000 que solicite por teclado dos números
# enteros estrictamente positivos: una base (B) y un exponente máximo (E). El programa 
# principal (main) debe pasarle dichos parámetros a una subrutina intermedia llamada 
# calcular_serie.
# La subrutina calcular_serie debe iterar desde 1 hasta E, y en cada iteración deberá
# invocar a una subrutina matemática llamada potencia (que recibe la base y el
# exponente actual, y devuelve el resultado de esa potencia). calcular_serie debe
# acumular la suma de todas las potencias y retornar el resultado final al programa
# principal para ser impreso en pantalla.
# El programa debe repetir toda su ejecución (pidiendo nuevos pares de números) hasta
# que el usuario ingrese un en la base, momento en el cual el programa debe finalizar.

# Ejemplo de ejecución:
# Introduzca la base: 2
# Introduzca el exponente maximo: 3
# La sumatoria de potencias es: 14
# Introduzca la base: 5
# Introduzca el exponente maximo: 2
# La sumatoria de potencias es: 30
# Introduzca la base: 0
# Fin del programa

