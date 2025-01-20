                AREA asm, CODE, READONLY
                EXPORT avg_vett

					;	R0 VETT
					;	R1 dim
					;	R2 flag
					
					
					
avg_vett				PROC
						STMFD 	SP!,{R4-R8,R10-R11,LR}		;SALVO REGISTRI VOLATILI
						
						MOV R8, #0 	; INIZIALIZZA IL CONTATORE DEI VALORI
						MOV R3, R1 	; COPIA dim IN R3
						MOV R4, R0 	; COPIA IL PUNTATORE AL VETTORE IN R4
						MOV R6, #0	; INIZIALIZZO R6 A 0 PER SALVARCI LA SOMMA
						MOV R7, #0	; PER CALCOLARE LA MEDIA
						
LOOP					CMP R3, #0
						BEQ AVERAGE
						
						LDR r5, [r0, r4, LSL #2] 	
						ADD R6, R6, R5 		; SOMMO TUTTI I VALORI PER OTTENERE LA MEDIA
						
						sub r3, r3, #1
						B LOOP

AVERAGE					UDIV R7, R6, R3

P_2						MOV R4, R0 	; COPIA IL PUNTATORE AL VETTORE IN R4
						MOV R3, R1	
						
LOOP2					CMP R3, #0
						BEQ SET_FLAG
						
						LDR r5, [r0, r4, LSL #2] 	
						CMP R5, R7
						BGT IS_GREATER
						
						SUB R3, R3, #1
						B LOOP

IS_GREATER				ADD R8, R8, #1
						SUB R3, R3, #1
						B LOOP2

SET_FLAG				TST R8, #1
						MOVEQ   R10, #1          ; se Z=1 => (R7 & 1)==0 => count e' pari => R8=1
						MOVNE   R10, #0          ; se Z=0 => count e' dispari => R8=0

						; Memorizza R8 (1 o 0) in *flag come char
						STRB    R10, [R2]

						; Ritorna count in R0
						MOV     R0, R8
						B       FINE

FINE				;MOV R0, R2
					LDMFD 	SP!,{R4-R8,R10-R11,PC}		;RIPRISTINO REGISTRI VOLATILI
					ENDP
					END