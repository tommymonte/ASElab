				AREA	svc_code, CODE, READONLY
call_svc		PROC
				EXPORT call_svc
					
				SVC	0x06	
				BX	LR
					
				ENDP
					
				END