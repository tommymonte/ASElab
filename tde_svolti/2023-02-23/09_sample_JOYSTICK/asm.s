                AREA asm, CODE, READONLY
                EXPORT concat_sum

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
	;	- **`BVS`**: Salta se il flag V è impostato (overflow).
	;	- **`BVC`**: Salta se il flag V non è impostato (nessun overflow).
	;	- **`BCS`**: Salta se il flag C è impostato (carry).
	;	- **`BCC`**: Salta se il flag C non è impostato (nessun carry).
	
					;	R0 VETT
					;	R1 dim
					;	R2 * alarm 
					
concat_sum				PROC
						STMFD 	SP!,{R4-R8,R10-R11,LR}		;SALVO REGISTRI VOLATILI
						MOV R4, #0
						MOV R8, #0
						MOV R10, #0
						
						; cerchiamo la prima posizione libera
CHECK_FIRST 			CMP R4, R1
						BEQ FINE
						
						LDR R6, [R0, R4, LSL #0]
						ADD R4, R4, #1	; incremento index count
						
						LDR R7, [R0, R4, LSL #1]
						LSL R7 , R7, #16
						ADD R4, R4, #1	; incremento index count
						
						ADD R8, R7, R6
						ADDS R10, R10, R8
						BVS CE_OVF
						BVC	NO_OVF

CE_OVF					MOV R11, #-1
						B CHECK_FIRST
						
NO_OVF					MOV R11, #0
						B CHECK_FIRST
						
FINE				STRB  R11, [R2]
					MOV R0, R10
					LDMFD 	SP!,{R4-R8,R10-R11,PC}		;RIPRISTINO REGISTRI VOLATILI
					ENDP
					END