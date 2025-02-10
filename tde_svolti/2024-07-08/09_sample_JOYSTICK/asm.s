                AREA asm, CODE, READONLY
                EXPORT analisi_accuratezza

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
					;	R1 VETT2
					;	R2 N
					; 	R3 RES
					; 	LDRB R4, [R12] 	; boundary BOUNDARY è posizionato 16 byte sopra SP (dopo 4 parametri * 4 byte ciascuno) BOUNDARY
				
analisi_accuratezza		PROC
						STMFD 	SP!,{R4-R8,R10-R11,LR}		;SALVO REGISTRI VOLATILI
						MOV	R4, #0	; INDEX
						MOV R7, #0	; RES
						MOV R8, #0	; SUM DI RES
						MOV R10, #0	; AVG
						
						; FINE VETT?
LOOP		 			CMP R4, R2
						BEQ AVG
						LDRB R5, [R0, R4]
						LDRB R6, [R1, R4]
						SUB R7, R6, R5 ; CALCOLO RES
		
						CMP R7, #0
						BLT ABS ; SE è NEGATIVO CALCOLO IL VAL ASS
						
						B STORE_RES
						
ABS 					RSB R7, R7, #0

STORE_RES				ADD R8, R8, R7 ; AGGIORNO LA SOMMA DEI RES
						STRB R7, [R3, R4] ; STORE DI RES 
						ADD R4, R4, #1	; INCREMENTO INDEX
						B LOOP
						
AVG						UDIV R10, R8, R2	; CALCOLO LA MEDIA
						MOV R0, R10			; SALVO IN R0 LA MEDIA COME OUTP
						
FINE					LDMFD 	SP!,{R4-R8,R10-R11,PC}		;RIPRISTINO REGISTRI VOLATILI
						ENDP
						END