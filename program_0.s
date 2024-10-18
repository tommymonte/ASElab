.data                   # Sezione dati
v1:  	.byte    	2, 6, -3, 11, 9, 18, -13, 16, 5, 1
v2:  	.byte    	4, 2, -13, 3, 9, 9, 7, 16, 4, 7
v3: .space 10               # Terzo vettore (per i match)
flag1: .byte 1
flag2: .byte 0
flag3: .byte 0
    .text                   # Sezione codice
main: 
    daddi R1,R0,0
    daddi R2,R0,0   # indice v1 
    daddi R3,R0,0   # indice v2
    daddi R8,R0,0   # indice v3
    daddi R4, R1, 10    # Lunghezza dei vettori (10 elementi)

    daddi R10, R0, 1 # uso un reg settato a 1 per andare a inserire il flag a 1

    # sb R10, flag1(R0) # significa salvo in flag1 il valore di R10, in questo caso 1
    # --> tra parentesi l'indice, in questo caso flag è un byte quindi indice R0 vuol dire indice 0

loop:
    lb R5,v1(R2)    # salvo v1 in R5, uso lb per salvare il singolo byte
    lb R6,v2(R3)    # salvo v2 in R6

    beq R2, R4, check_flags    # Se l'indice è uguale a 10, termina il ciclo

    beq R5, R6, match      # Se v1[i] == v2[i], salta a match
    beq R3, R4, restart_loop # devo resettare l'indice di v2 se arriva a 10

    j no_match             # Altrimenti, salta a no_match

match:
    sb R5, v3(R8)            # Memorizza il valore corrispondente in v3
    sb R0, flag1(R0) 
    daddi R1, R1, 1         # Incrementa 
    daddi R2, R2, 1         # Incrementa il puntatore di v1
    daddi R3, R0, 0         # azzera il puntatore di v2
    daddi R8, R8, 1         # Incrementa il puntatore di v3
    j loop

no_match:
    daddi R3, R3, 1

    j loop                  # Ripeti il ciclo

restart_loop:
    daddi R3, R0, 0 # se l'indice del secondo vettore arriva a 10 lo azzero e incremento v1
    daddi R2, R2, 1 # incremento indice di v1

    j loop

check_flags:
    lb R11, flag1(R0)                # Carica il valore di flag1
    bnez R11, end_loop                # Se flag1 != 0 (v3 è vuoto), salta a END
    dadd R2,R0, R0   # indice per il flag2
    dadd R3,R0,R0  # indice per il flag3
    dadd R4, R0, R0

LOOPFLAG2:
    beq R2, R8, LOOPFLAG3     # Se abbiamo finito il vettore, controlla flag3
    lb R5, v3(R2)              # Carica v3[R2]
    daddi R2, R2, 1            # Incrementa R2
    lb R6, v3(R2)              # Carica v3[R2 + 1]
    slt R4, R5, R6             # Verifica se v3[R2] < v3[R2 + 1]
    bne R4, R0, LOOPFLAG3     # Se non è vero, passa al flag3
    sb R4, flag2(R0)          # Imposta flag2 a 1
    j LOOPFLAG2              

LOOPFLAG3:
    beq R3, R8, end_loop      # Se abbiamo finito il vettore, esci
    lb R5, v3(R3)             # Carica v3[R3]
    daddi R3, R3, 1           # Incrementa R3
    lb R6, v3(R3)             # Carica v3[R3 + 1]
    slt R4, R6, R5            # Verifica se v3[R3] < v3[R3 + 1]
    bne R4, R0, end_loop      # Se non è vero, fine
    sb R4, flag3(R0)         # Imposta flag3 a 1
    j LOOPFLAG3

end_loop:
    HALT

