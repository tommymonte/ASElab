.data
v1:    	.double		8.90, 9.12, 10.23, 11.34, 12.45, 13.56, 14.67, 58.56
		.double		15.78, 16.89, 17.90, 18.12, 19.23, 20.34, 21.45, 59.67
        .double     36.12, 37.23, 38.34, 39.45, 40.56, 41.67, 42.78, 62.90
		.double		43.89, 44.90, 45.12, 46.23, 47.34, 48.45, 49.56, 63.12  

v2:     .double		8.90, 9.12, 10.23, 11.34, 12.45, 13.56, 14.67, 58.56
		.double		15.78, 16.89, 17.90, 18.12, 19.23, 20.34, 21.45, 59.67
        .double     36.12, 37.23, 38.34, 39.45, 40.56, 41.67, 42.78, 62.90
		.double		43.89, 44.90, 45.12, 46.23, 47.34, 48.45, 49.56, 63.12  

v3:     .double		8.90, 9.12, 10.23, 11.34, 12.45, 13.56, 14.67, 58.56
		.double		15.78, 16.89, 17.90, 18.12, 19.23, 20.34, 21.45, 59.67
        .double     36.12, 37.23, 38.34, 39.45, 40.56, 41.67, 42.78, 62.90
		.double		43.89, 44.90, 45.12, 46.23, 47.34, 48.45, 49.56, 63.12  
     
v4:     .space 256
v5:     .space 256
v6:     .space 256

a:      .space 8
b:      .double 22.25

m:      .word   1

.text
main: 
    daddi R1, R0, 248       # 1 index for loop
    daddi R2, R0, -8        # 1
    daddi R3, R0, 31
    daddi R4, R0, 3

    ld R7, m(R0)            # load m
    l.d f8, b(R0)           # load b

loop: 
    beq R1, R2, END         # termina se R1 == R2
    
    ddivu R5, R3, R4        # R5 = R3 / R4
    dmulu R6, R5, R4        # R6 = R5 * R4

    l.d f1, v1(R1)          # carica v1
    l.d f2, v2(R1)          # carica v2
    l.d f6, v3(R1)          # carica v3
    # Condizione per multiplo di 3
    bne R6, R3, ELSECOND    # Salta a ELSECOND se non è multiplo di 3

    # IFCOND
    dsllv R7, R7, R3        # Shift sinistra
    mtc1 R7, f3             # sposto in f3
    cvt.d.l f3, f3          # converto in doppia precisione

    div.d f4, f1, f3        # f4 = f1 / f3
    s.d f4, a(R0)           # salvo in a
    mfc1 R7, f4             # m = int a (conversione a intero)
    
    # Operazioni finali
    j FINALCALC

ELSECOND:
    # ELSECOND
    mtc1 R7, f3             # sposto in f3
    cvt.d.l f3, f3          # converto in doppia precisione
    mul.d f4, f1, f3        # f4 = f1 * f3
    s.d f4, a(R0)           # salvo in a
    mfc1 R7, f4             # m = int a (conversione a intero)

FINALCALC:
    # Operazioni comuni dopo la condizione
    mul.d f5, f4, f1        # f5 = f4 * f1
    
    # Aggiornamento indici ciclo
    daddi R1, R1, -8        # decrementa R1 di 8
    daddi R3, R3, -1        # decrementa R3 di 1

    sub.d f5, f5, f2        # f5 = f5 - f2

    div.d f7, f5, f6        # f7 = f5 / f6, non posso spostarla, dipende d f5

    s.d f5, v4(R1)          # salvo in v4

    sub.d f7, f7, f8        # f7 = f7 - f8
    sub.d f9, f5, f1        # f9 = f5 - f1, sposto la sub

    s.d f8, v5(R1)          # salvo in v5

    mul.d f9, f9, f8        # f9 = f9 * f8
    s.d f8, v6(R1)          # salvo in v6

    j loop                  # ripeti ciclo

END:
    HALT                    # termina

