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

# loop unrolling --> dobbiamo schedulare il ciclo 3 alla volta
.text
main: 
    daddi R1, R0, 248       # 1 index for loop
    daddi R8, R0, 240
    daddi R9, R0, 232

    daddi R2, R0, -8        # 1
    daddi R3, R0, 31
    daddi R4, R0, 3

    ld R7, m(R0)            # load m
    l.d f8, b(R0)           # load b

LOOP1: 
    beq R9, R2, END         # termina se R9 == R2 
    l.d f1, v1(R1)          # carica v1
    l.d f2, v2(R1)          # carica v2
    l.d f6, v3(R1)          # carica v3
    
    # ELSECOND (o quello che era) -- alla prima iterazione (i=31) vado direttamente all'else
    # alla fine decremento di 3 quindi quando eseguirò di nuovo questo loop sarò i=28,25,22,19... 
    # quindi mai multipli di 3

    mtc1 R7, f3             # sposto in f3
    cvt.d.l f3, f3          # converto in doppia precisione
    mul.d f4, f1, f3        # f4 = f1 * f3
    s.d f4, a(R0)           # salvo in a
    mfc1 R7, f4             # m = int a (conversione a intero)    

    # Operazioni comuni dopo la condizione
    mul.d f5, f4, f1        # f5 = f4 * f1
    
    # Aggiornamento indici ciclo
    daddi R1, R1, -24        # decrementa R1 di 8*3
    # daddi R3, R3, -1        # decrementa R3 di 1  questa op diventa inutile dato che non devo più controllare se multiplo

    sub.d f5, f5, f2         # f5 = f5 - f2 --> v4[i] = av1[i] - v2[i] 
    div.d f7, f5, f6         # f7 = f5 / f6

    s.d f5, v4(R1)           # salvo in v4

    sub.d f7, f7, f8         # f7 = f7 - f8
    sub.d f9, f5, f1         # f9 = f5 - f1

    s.d f8, v5(R1)           # salvo in v5

    mul.d f9, f9, f8         # f9 = f9 * f8
    # delay slot
    s.d f9, v6(R1)           # salvo in v6

LOOP2:
    l.d f1, v1(R8)          # carica v1
    l.d f2, v2(R8)          # carica v2
    l.d f6, v3(R8)          # carica v3
    
    # IFCOND --> alla seconda iterazione avrò i=30.. poi i=27,24.. ecc quindi sempre multipli di 3
    # devo eseguire sempre l'if
    dsllv R7, R7, R3        # Shift sinistra
    mtc1 R7, f3             # sposto in f3
    cvt.d.l f3, f3          # converto in doppia precisione

    div.d f4, f1, f3        # f4 = f1 / f3
    s.d f4, a(R0)           # salvo in a
    mfc1 R7, f4             # m = int a (conversione a intero)

    # Operazioni comuni dopo la condizione
    mul.d f5, f4, f1        # f5 = f4 * f1
    
    # Aggiornamento indici ciclo
    daddi R8, R8, -24        # decrementa R1 di 8

    sub.d f5, f5, f2         # f5 = f5 - f2 --> v4[i] = av1[i] - v2[i] 
    div.d f7, f5, f6         # f7 = f5 / f6

    s.d f5, v4(R8)           # salvo in v4

    sub.d f7, f7, f8         # f7 = f7 - f8
    sub.d f9, f5, f1         # f9 = f5 - f1

    s.d f8, v5(R8)           # salvo in v5

    mul.d f9, f9, f8         # f9 = f9 * f8
    s.d f9, v6(R8)           # salvo in v6

LOOP3:
    l.d f1, v1(R9)          # carica v1
    l.d f2, v2(R9)          # carica v2
    l.d f6, v3(R1)          # carica v3

    # ELSECOND
    mtc1 R7, f3             # sposto in f3
    cvt.d.l f3, f3          # converto in doppia precisione
    mul.d f4, f1, f3        # f4 = f1 * f3
    s.d f4, a(R0)           # salvo in a
    mfc1 R7, f4             # m = int a (conversione a intero)

    # Operazioni comuni dopo la condizione
    mul.d f5, f4, f1        # f5 = f4 * f1
    
    # Aggiornamento indici ciclo
    daddi R9, R9, -24        # decrementa R1 di 8

    sub.d f5, f5, f2         # f5 = f5 - f2 --> v4[i] = av1[i] - v2[i] 
    div.d f7, f5, f6         # f7 = f5 / f6

    s.d f5, v4(R9)           # salvo in v4

    sub.d f7, f7, f8         # f7 = f7 - f8
    sub.d f9, f5, f1         # f9 = f5 - f1

    s.d f8, v5(R9)           # salvo in v5

    mul.d f9, f9, f8         # f9 = f9 * f8
    
    j LOOP1                   # ripeti ciclo
    # delay slot
    s.d f9, v6(R9)           # salvo in v6

END:
    HALT                    # termina