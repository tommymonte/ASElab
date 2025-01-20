                AREA asm, CODE, READONLY
                EXPORT count_negative_and_odd


					

					
					;	R0 VETT
					;	R1 n
					
					
					
count_negative_and_odd	PROC
						STMFD 	SP!,{R4-R8,R10-R11,LR}		;SALVO REGISTRI VOLATILI
						
						MOV R2, #0 	; INIZIALIZZA IL CONTATORE DEI VALORI
						MOV R3, R1 	; COPIA N IN R3
						MOV R4, R0 	; COPIA IL PUNTATORE AL VETTORE IN R4

LOOP					CMP R3, #0
						BEQ FINE
						
						LDR r5, [r0, r4, LSL #2]
						CMP R5, #0	; COMPARA A 0
						BGT NEXT	; ESCI SE è MAGGIORE DI 0
						TST R5, #1 	; CONTROLLA SE DISPARI
						BEQ NEXT	; =0 SALTA AL PROSSIMO
						
						ADD R2, R2, #1

NEXT					ADD R4, R4, #1
						sub r3, r3, #1
						B LOOP
						


FINE				MOV R0, R2
					LDMFD 	SP!,{R4-R8,R10-R11,PC}		;RIPRISTINO REGISTRI VOLATILI
					ENDP
					END