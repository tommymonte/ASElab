                AREA asm, CODE, READONLY
                EXPORT check_fibonacci

	; 1) salva i registri come input nei nuovi registri, da r4 in poi
	; 	NB: se hai più di 4 input il 5 devi salvarlo così:
	;		MOV R12, SP		
	;		LDRB R4, [R12] 	
	
	; 2) se devi caricare un vettore con valori da 32 bit usa -->  LDR R6, [R0, R4, LSL #2] 
	;	 - R0 punta all'indirizzo base vettore
	;	 - R4 è l'indice del vettore, R6 dove salvi il valore
	; 	 - LSL #2 shifta l'indirizzo base del vettore di 4 byte
	; 	se invece ha elementi da 8 bit, basta usare LDRB
	; 		LDRB R6, [R0, R4]
	;	NB: devi poi incrementare R4 ovvero l'offset
	
	; 3) se devi verificare che un numero sia pari o dispari usa
	;		TST R4, #1
	;		MOVEQ R5, #1 --> è pari
	; 		MOVNE R5, #0 --> dipari
	
	; 4) se devi salvare un valore a un puntatore utilizza STRB R4, [R0]
	;		R0 è il registro di input in cui viene passato il puntatore
	; 		R4 è il valore che vuoi salvare
	
	; 5) se voglio fare abs(-2) devo fare:
	; 	check_abs	CMP R0, #0
	;				BLT abs
	;  	abs  		RSB R0, R0, #0 --> rsb fa una reverse sub: 0 - (-2) = +2
	; 				B check_abs
	
	
					;	R0 VETT
					;	R1 N elementi
					;	R2 M 
					; 	R3 VAL
					; 	LDRB R4, [R12] 	; boundary BOUNDARY è posizionato 16 byte sopra SP (dopo 4 parametri * 4 byte ciascuno) BOUNDARY

					
check_fibonacci			PROC
						MOV R12, SP
						STMFD 	SP!,{R4-R8,R10-R11,LR}		;SALVO REGISTRI VOLATILI
						LDRB R4, [R12] 	; boundary
						MOV R5, #0 	; index
						
						; cerchiamo la prima posizione libera
CHECK_FIRST 			CMP R5, R1
						BEQ NON_ACCETTABILE
						LDRB R6, [R0, R5]
						CMP R6, #0
						BEQ FREE_POS
						
						ADD R5, R5, #1	; incremento index count
						B CHECK_FIRST

FREE_POS				
						MOV R7, #0
						MOV R8, #1
						MOV R10, #0 ; INDICE PER M

CHECK_FIBO				CMP R10, R2 ; CMP CON M
						BEQ ACCETTABILE	; SONO ARRIVATO A 14 VUOL DIRE CHE HO CONFRONTATO TUTTI I VALORI QUINDI è ACCETTABILE
						
						; GUARDO SE VAL è ACCETTABILE
						; PRIMA GUARDO SE è UGUALE A UN NUMERO DELLA SERIE
						CMP R3, R7
						BEQ NON_ACCETTABILE	
						CMP R3, R8
						BEQ NON_ACCETTABILE
						SUB R11, R3, R7
						
CHECK_BOUNDARY			CMP R11, #0
						BLT ABS
						
						CMP R11, R4
						BLE NON_ACCETTABILE     ; val <= boundary --> fine
						
						ADD R10, R10, #2
							
						; AGGIORNO LA SERIE
						; 0 1 --> 1 2 --> 3 5 --> 8 13 ...
						ADD R7, R7, R8
						ADD R8, R8, R7
						B CHECK_FIBO

ABS 					RSB R11, R11, #0
						B CHECK_BOUNDARY

ACCETTABILE				;LSL R5, R5, #2
						ADD R5, R0, R5
						STRB R3, [R5]

						MOV R0, #1
						B FINE
						
NON_ACCETTABILE			MOV R0, #0
						B FINE
						
						
FINE				LDMFD 	SP!,{R4-R8,R10-R11,PC}		;RIPRISTINO REGISTRI VOLATILI
					ENDP
					END