					AREA my_data, READONLY	
					ALIGN 2			
					EXPORT  Matrix_Coordinates
					EXPORT  ROWS 
					EXPORT	COLUMNS
					
Matrix_Coordinates 	DCD -5,5,-4,5,-3,5,-2,5,-1,5,0,5,1,5,2,5,3,5,4,5,5,5
					DCD -5,4,-4,4,-3,4,-2,4,-1,4,0,4,1,4,2,4,3,4,4,4,5,4
					DCD -5,3,-4,3,-3,3,-2,3,-1,3,0,3,1,3,2,3,3,3,4,3,5,3
					DCD -5,2,-4,2,-3,2,-2,2,-1,2,0,2,1,2,2,2,3,2,4,2,5,2
					DCD -5,1,-4,1,-3,1,-2,1,-1,1,0,1,1,1,2,1,3,1,4,1,5,1
					DCD -5,0,-4,0,-3,0,-2,0,-1,0,0,0,1,0,2,0,3,0,4,0,5,0
					DCD -5,-1,-4,-1,-3,-1,-2,-1, -1,-1 ,0,-1,1,-1,2,-1,3,-1,4,-1,5,-1
					DCD -5,-2,-4,-2,-3,-2,-2,-2,-1,-2,0,-2,1,-2,2,-2,3,-2,4,-2,5,-2
					DCD -5,-3,-4,-3,-3,-3,-2,-3,-1,-3,0,-3,1,-3,2,-3,3,-3,4,-3,5,-3
					DCD -5,-4,-4,-4,-3,-4,-2,-4,-1,-4,0,-4,1,-4,2,-4,3,-4,4,-4,5,-4
					DCD -5,-5,-4,-5,-3,-5,-2,-5,-1,-5,0,-5,1,-5,2,-5,3,-5,4,-5,5,-5
ROWS 				DCB 11
COLUMNS 			DCB 22

					AREA asm_functions, CODE, READONLY	
my_division   		PROC
					IMPORT __aeabi_fdiv
					EXPORT  my_division     

					STMFD 	SP!, {R4-R7, LR}
					
					LDR		R4, [R0]
					LDR		R5, [R1]
					
					MOV		R0, R4
					MOV		R1, R5
					
					BL		__aeabi_fdiv
				
					LDMFD 	SP!, {R4-R7, PC}
				
					BX 		LR
					ENDP
					

check_square		PROC
					EXPORT  check_square     

					STMFD 	SP!, {R4-R11, LR}
					
					MUL		R0, R0, R0
					MUL		R1, R1, R1
					MUL		R2, R2, R2
					ADD		R0, R0, R1
					CMP		R0, R2
					MOVGT	R0, #0
					MOVLE	R0, #1
					
					LDMFD 	SP!, {R4-R11, PC}
					
					BX 		LR
					ENDP
					
					END