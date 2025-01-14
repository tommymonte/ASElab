                AREA asm, CODE, READONLY
                EXPORT sopra_la_media

sopra_la_media
                PUSH    {R4-R7, LR}       ; Salva i registri usati
                MOV     R4, R0            ; R4 = indirizzo dell'array (VETT)
                MOV     R5, R1            ; R5 = numero di elementi (n)
                MOV     R6, #0            ; Somma = 0 (R6)
                MOV     R7, #0            ; Conteggio sopra media = 0 (R7)

                ; Calcolo della somma
loop_sum        LDRB    R3, [R4], #1      ; Carica il prossimo elemento (8-bit) e incrementa R4
                ADD     R6, R6, R3        ; Aggiunge il valore alla somma
                SUBS    R5, R5, #1        ; Decrementa il conteggio
                BNE     loop_sum          ; Continua finché ci sono elementi

                ; Calcolo della media
                MOV     R5, R1            ; Ripristina il numero di elementi (n)
                MOV     R0, R6            ; R0 = somma totale
                UDIV    R0, R0, R5        ; R0 = somma / n (media)

                ; Conta i valori sopra la media
                MOV     R4, R1            ; R4 = indirizzo dell'array (reset)
                MOV     R5, R1            ; R5 = numero di elementi (n)
                MOV     R6, R0            ; R6 = media
loop_count      LDRB    R3, [R4], #1      ; Carica il prossimo elemento
                CMP     R3, R6            ; Confronta con la media
                BLS     skip_count        ; Salta se <= media
                ADD     R7, R7, #1        ; Incrementa il conteggio sopra media
skip_count      SUBS    R5, R5, #1        ; Decrementa il conteggio
                BNE     loop_count        ; Continua finché ci sono elementi

                ; Ritorno del risultato
                MOV     R0, R7            ; R0 = risultato (conteggio sopra media)
                POP     {R4-R7, PC}       ; Ripristina i registri e ritorna

                END
