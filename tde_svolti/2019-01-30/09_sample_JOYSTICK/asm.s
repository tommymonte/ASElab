        AREA asm, CODE, READONLY
        EXPORT divisible

;   R0 = e1 (dividendo)
;   R1 = e2 (divisore)
;
;   Ritorno in R0 = 0 se e1 è divisibile da e2,
;               altrimenti e1 % e2

divisible  PROC
    STMFD   SP!, {R4-R8, R10-R11, LR}      ; Salva registri volatili

    MOV     R2, R0          ; Copio e1 in R2
    MOV     R3, R1          ; Copio e2 in R3

START
    ; Calcoliamo il quoziente = e1 / e2
    UDIV    R4, R2, R3      ; R4 = R2 / R3 (quoziente)
    ; Calcoliamo quoziente * e2
    MUL     R5, R4, R3      ; R5 = R4 * R3
    ; Resto = e1 - (quoziente*e2)
    SUB     R6, R2, R5      ; R6 = R2 - R5 (resto)

    CMP     R6, #0
    BEQ     IS_DIVISIBLE    ; Se resto=0 => divisibile
    BNE     NOT_DIVISIBLE   ; Altrimenti => non divisibile

IS_DIVISIBLE
    MOV     R0, #0          ; e1 è divisibile ? ritorniamo 0
    B       FINE

NOT_DIVISIBLE
    MOV     R0, R6          ; e1 non è divisibile ? ritorniamo il resto
    B       FINE

FINE
    LDMFD   SP!, {R4-R8, R10-R11, PC}      ; Ripristina registri e torna
    ENDP
    END
