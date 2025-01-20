                AREA asm, CODE, READONLY
                EXPORT avg_vett

	; 1) salva i registri come input nei nuovi registri, da r4 in poi
	; 2) se devi caricare un vettore usa -->  LDR R6, [R0, R4, LSL #2] 
	;	 R0 punta all'indirizzo base vettore
	;	 R4 è l'indice del vettore, R6 dove salvi il valore
	; 	 LSL #2 shifta l'indirizzo base del vettore di 4 byte
	; 3) se devi verificare che un numero sia pari o dispari usa
	;		TST R4, #1
	;		MOVEQ R5, #1 --> è pari
	; 		MOVNE R5, #0 --> dipari
	; 4) se devi salvare un valore a un puntatore utilizza STRB R4, [R0]
	;		R0 è il registro di input in cui viene passato il puntatore
	; 		R4 è il valore che vuoi salvare
	
					;	R0 VETT
					;	R1 dim
					;	R2 flag

					
avg_vett				PROC
						STMFD 	SP!,{R4-R8,R10-R11,LR}		;SALVO REGISTRI VOLATILI
						
						MOV R4, #0	; INDEX
						MOV R5, #0 	; SOMMA VALORI

LOOP 					CMP R4, R1
						BEQ AVERAGE
						LDR R6, [R0, R4, LSL #2]
						ADD R5, R5, R6
						
						ADD R4, R4, #1
						B LOOP

AVERAGE 				MOV R7, #0
						UDIV R7, R5, R1 	; R7 = R6/R1

CHECK					MOV R4, #0
						MOV R8, #0

LOOP2					CMP R4, R1
						BEQ ODD_EVEN_CHECK
						LDR R6, [R0, R4, LSL #2]
						CMP R6, R7
						BGT IS_HIGHER
						
						ADD R4, R4, #1
						B LOOP2

IS_HIGHER				ADD R8, R8, #1
						ADD R4, R4, #1
						B LOOP2
						
ODD_EVEN_CHECK			TST R8, #1
						MOVEQ R10, #1
						MOVNE R10, #0
						STRB R10, [R2]
						
FINE				MOV R0, R8
					LDMFD 	SP!,{R4-R8,R10-R11,PC}		;RIPRISTINO REGISTRI VOLATILI
					ENDP
					END