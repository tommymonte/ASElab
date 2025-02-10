                AREA asm, CODE, READONLY
                EXPORT differenza_media_positivi_negativi

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
	
	; 6) **Istruzioni di Branch:**
	; 	- UTILIZZARE ADDS
	;	- **`BVS`**: Salta se il flag V ? impostato (overflow).
	;	- **`BVC`**: Salta se il flag V non ? impostato (nessun overflow).
	;	- **`BCS`**: Salta se il flag C ? impostato (carry).
	;	- **`BCC`**: Salta se il flag C non ? impostato (nessun carry).
	
					;	R0 VETT
					;	R1 N elementi
					;	R2 * over 
				
differenza_media_positivi_negativi	PROC
									STMFD 	SP!,{R4-R8,R10-R11,LR}		;SALVO REGISTRI VOLATILI
									MOV R4, #0 	; index
									MOV R5, #0	; SUM GT0
									MOV R6, #0	; SUM LT0
									MOV R8, #0	; CNT LESS
									MOV R10, #0 ; CNT OVER
						; cerchiamo la prima posizione libera
LOOP		 			CMP R4, R1
						BEQ AVG
						LDR R7, [R0, R4, LSL #2]
						CMP R7, #0
						BLT is_neg		; SE è <0 SALTO
						ADD R5, R5, R7
						ADD R10, R10, #1
						ADD R4, R4, #1
						B LOOP

is_neg					ADDLT R6, R6, R7
						ADD R8, R8, #1
						ADD R4, R4, #1
						B LOOP
						
AVG						SDIV R11, R5, R10
						SDIV R4, R6, R8
						SUB R7, R11, R4
						BVS SET_OVF
						BVC FINE
						
SET_OVF 				MOV R4, #255
						STRB R4, [R2]
						

						
FINE				MOV R0, R7
					LDMFD 	SP!,{R4-R8,R10-R11,PC}		;RIPRISTINO REGISTRI VOLATILI
					ENDP
					END