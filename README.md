# MIPS Assembly - Arquitectura de las Computadoras I

Repositorio con los ejercicios resueltos de las prácticas de la materia **Arquitectura de las Computadoras I** (Analista Universitario en Sistemas).

## 🛠️ Herramientas y Entorno
* **Lenguaje:** MIPS R2000 Assembly
* **Simulador:** [MARS (MIPS Assembler and Runtime Simulator)](https://computerscience.missouristate.edu/mars-mips-simulator.htm) — Requiere **Java (JRE)**.
* **Entorno de ejecución:** [Java Runtime Environment (JRE)](https://www.java.com/es/download/manual.jsp)

---

## 📂 Estructura del Repositorio

### 📄 `Practica-1/`: Manejo de Memoria y Representación de Datos
* **Directivas de memoria:** Uso de `.data`, `.text`, `.word`, `.byte`, `.ascii`, `.asciiz` y `.space`.
* **Alineación de memoria:** Manejo de direcciones alineadas a palabra (`.align`) y resolución de excepciones de desalineación.
* **Organización de datos:** Almacenamiento de variables, vectores, matrices (por filas y por columnas) y formato *Little-Endian*.

### 📄 `Practica-2/`: Acceso a Registros, Instrucciones y Aritmética
* **Carga y almacenamiento:** Uso de `lw`, `lh`, `lb`, `sw`, `sh`, `sb`, `lui`, `li` y `la`.
* **Operaciones aritméticas:** Modos de direccionamiento, manejo de enteros con y sin signo (`add`, `sub`, `addi`, `addiu`, `subu`) y detección de desbordamiento (overflow).
* **Multiplicación y División:** Manejo de registros especiales `hi` y `lo` con `mult`, `div`, `mfhi` y `mflo`.
* **Operaciones Lógicas y Desplazamiento:** Manipulación de bits con `and`, `andi`, `or`, `ori`, `xor`, `nor`, y desplazamientos `sll`, `srl`, `sra`.

### 📄 `Practica-3/`: Control de Flujo, Condicionales y Bucles
* **Saltos condicionales e incondicionales:** Implementación de `beq`, `bne`, `beqz`, `bnez`, `slt`, `sle`, `sgt` y saltos directos `j`.
* **Estructuras de control:** Traducción de expresiones lógicas compuestas, bloques `if-then-else` y evaluación corta (*short-circuit*).
* **Iteraciones y Bucles Anidados:** Implementación eficiente de bucles `while`, `for`, recorrido de vectores/cadenas y algoritmos de ordenamiento (ej. *Bubble Sort*).

### 📄 `Subrutinas/`: Manejo de Funciones, Pila (Stack) y Syscalls
* **Subrutinas Hoja (*Leaf Procedures*):** Prólogo y epílogo, ajuste del puntero de pila (`$sp`), preservación de registros guardados (`$s0`-`$s7`) y uso de `jr $ra`.
* **Subrutinas No Hoja y Recursión (*Non-Leaf Procedures*):** Preservación de la dirección de retorno (`$ra`) en la pila para llamadas anidadas y recursivas (ej. cálculo de Factorial).
* **Módulos I/O y Reutilización:** Abstracción de llamadas al sistema (*syscalls*) en subprogramas modulares (`PromptInt`, `PrintInt`, `PrintString`, `ImprimirNuevaLinea`, `Exit`).
* **Pasaje de Parámetros:** Convención estándar de MIPS utilizando registros de argumentos (`$a0`-`$a3`) y retorno de valores (`$v0`-`$v1`).

### 📄 `Practica-examen/`: Ejercicios Integradores y Modelos de Examen
* **Búsqueda de Máximo en Vector (`Ejercicio1.asm`):** Recorrido de vector en memoria estática delegando comparaciones mediante subrutinas no hoja (`encontrar_maximo` -> `max`) con preservación de `$ra` y registros guardados.
* **Modificación de Vector en Memoria (`Ejercicio2.asm`):** Iteración y actualización directa en memoria mediante subrutinas anidadas (`modificar_vector` -> `sumar_constante`), gestionando múltiples parámetros en registros `$a0` - `$a2`.
---

## 🚀 Cómo ejecutar los ejercicios en MARS

1. Asegurarse de tener instalado [Java (JRE)](https://www.java.com/es/download/manual.jsp).
2. Descargar el archivo ejecutable del simulador [MARS](https://computerscience.missouristate.edu/mars-mips-simulator.htm).
3. Abrir la consola de comandos en la carpeta donde se encuentra el archivo descargado y ejecutar:
   ```bash
   java -jar Mars4_5.jar
