
.data
palabra: 		.word 0x10203040	# Dirección: 0x10010000-0x10010003
resultado_bytes:	.space 4		# 0x10010004 - 0x10010007
resultado_half: 	.space 4		# 0x10010008 - 0x1001000B

.text
main:		la $s0, palabra	# Carga en el registro $s0, la dirección de palabra
		lb $s1, 0($s0)	# Carga en $s1 el byte en Addr+0 (0x40 en little-endian)
		lb $s2, 1($s0)	# Carga en $s2 el byte en Addr+1 (0x30 en little-endian)
		lb $s3, 2($s0)	# Carga en $s3 el byte en Addr+2 (0x20 en little-endian)
		lb $s4, 3($s0)	# Carga en $s4 el byte en Addr+3 (0x10 en little-endian)
		la $t0, resultado_bytes # Carga la dirección de resultado_bytes
		sb $s4, 0($t0)	# Guarda 0x10 en la dirección Dest + 0 (0x10010004)invertido
		sb $s3, 1($t0)	# Guarda 0x20 en la dirección Dest + 1 (0x10010005)invertido
		sb $s2, 2($t0)	# Guarda 0x30 en la dirección Dest + 2 (0x10010006)invertido
		sb $s1, 3($t0) 	# Guarda 0x40 en la dirección Dest + 3 (0x10010007)invertido
		lh $t1, 0($s0)	# Carga la media palabra inferior (0x3040) en $t1
		lh $t2, 2($s0)	# Carga la media palabra superior (0x1020) en $t2
		la $t3, resultado_half # Carga la dirección de resultado_half en $t3
		sh $t2, 0($t3)	# Guarda 0x1020 en los primeros 2 bytes de resultado_half
		sh $t1, 2($t3)	# Guarda 0x3040 en los siguientes 2 bytes de resultado_half