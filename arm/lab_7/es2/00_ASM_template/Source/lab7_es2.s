;/**************************************************************************//**
; * @file     startup_LPC17xx.s
; * @brief    CMSIS Cortex-M3 Core Device Startup File for
; *           NXP LPC17xx Device Series
; * @version  V1.10
; * @date     06. April 2011
; *
; * @note
; * Copyright (C) 2009-2011 ARM Limited. All rights reserved.
; *
; * @par
; * ARM Limited (ARM) is supplying this software for use with Cortex-M
; * processor based microcontrollers.  This file can be freely distributed
; * within development tools that are supporting such ARM based processors.
; *
; * @par
; * THIS SOFTWARE IS PROVIDED "AS IS".  NO WARRANTIES, WHETHER EXPRESS, IMPLIED
; * OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF
; * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE.
; * ARM SHALL NOT, IN ANY CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL, OR
; * CONSEQUENTIAL DAMAGES, FOR ANY REASON WHATSOEVER.
; *
; ******************************************************************************/

; *------- <<< Use Configuration Wizard in Context Menu >>> ------------------

; <h> Stack Configuration
;   <o> Stack Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Stack_Size      EQU     0x00000200

                AREA    STACK, NOINIT, READWRITE, ALIGN=3
Stack_Mem       SPACE   Stack_Size
__initial_sp


; <h> Heap Configuration
;   <o>  Heap Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Heap_Size       EQU     0x00000200

                AREA    HEAP, NOINIT, READWRITE, ALIGN=3	; 2*3
__heap_base
Heap_Mem        SPACE   Heap_Size
__heap_limit


                PRESERVE8
                THUMB


; Vector Table Mapped to Address 0 at Reset

                AREA    RESET, DATA, READONLY
                EXPORT  __Vectors

__Vectors       DCD     __initial_sp              ; Top of Stack
                DCD     Reset_Handler             ; Reset Handler
                DCD     NMI_Handler               ; NMI Handler
                DCD     HardFault_Handler         ; Hard Fault Handler
                DCD     MemManage_Handler         ; MPU Fault Handler
                DCD     BusFault_Handler          ; Bus Fault Handler
                DCD     UsageFault_Handler        ; Usage Fault Handler
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     SVC_Handler               ; SVCall Handler
                DCD     DebugMon_Handler          ; Debug Monitor Handler
                DCD     0                         ; Reserved
                DCD     PendSV_Handler            ; PendSV Handler
                DCD     SysTick_Handler           ; SysTick Handler

                ; External Interrupts
                DCD     WDT_IRQHandler            ; 16: Watchdog Timer
                DCD     TIMER0_IRQHandler         ; 17: Timer0
                DCD     TIMER1_IRQHandler         ; 18: Timer1
                DCD     TIMER2_IRQHandler         ; 19: Timer2
                DCD     TIMER3_IRQHandler         ; 20: Timer3
                DCD     UART0_IRQHandler          ; 21: UART0
                DCD     UART1_IRQHandler          ; 22: UART1
                DCD     UART2_IRQHandler          ; 23: UART2
                DCD     UART3_IRQHandler          ; 24: UART3
                DCD     PWM1_IRQHandler           ; 25: PWM1
                DCD     I2C0_IRQHandler           ; 26: I2C0
                DCD     I2C1_IRQHandler           ; 27: I2C1
                DCD     I2C2_IRQHandler           ; 28: I2C2
                DCD     SPI_IRQHandler            ; 29: SPI
                DCD     SSP0_IRQHandler           ; 30: SSP0
                DCD     SSP1_IRQHandler           ; 31: SSP1
                DCD     PLL0_IRQHandler           ; 32: PLL0 Lock (Main PLL)
                DCD     RTC_IRQHandler            ; 33: Real Time Clock
                DCD     EINT0_IRQHandler          ; 34: External Interrupt 0
                DCD     EINT1_IRQHandler          ; 35: External Interrupt 1
                DCD     EINT2_IRQHandler          ; 36: External Interrupt 2
                DCD     EINT3_IRQHandler          ; 37: External Interrupt 3
                DCD     ADC_IRQHandler            ; 38: A/D Converter
                DCD     BOD_IRQHandler            ; 39: Brown-Out Detect
                DCD     USB_IRQHandler            ; 40: USB
                DCD     CAN_IRQHandler            ; 41: CAN
                DCD     DMA_IRQHandler            ; 42: General Purpose DMA
                DCD     I2S_IRQHandler            ; 43: I2S
                DCD     ENET_IRQHandler           ; 44: Ethernet
                DCD     RIT_IRQHandler            ; 45: Repetitive Interrupt Timer
                DCD     MCPWM_IRQHandler          ; 46: Motor Control PWM
                DCD     QEI_IRQHandler            ; 47: Quadrature Encoder Interface
                DCD     PLL1_IRQHandler           ; 48: PLL1 Lock (USB PLL)
                DCD     USBActivity_IRQHandler    ; 49: USB Activity interrupt to wakeup
                DCD     CANActivity_IRQHandler    ; 50: CAN Activity interrupt to wakeup


                IF      :LNOT::DEF:NO_CRP
                AREA    |.ARM.__at_0x02FC|, CODE, READONLY
CRP_Key         DCD     0xFFFFFFFF
                ENDIF

var				RN 		2

				AREA |.data|, DATA, READWRITE, ALIGN=2
Best_times_ordered_ID 		SPACE 4*7
Best_times_ordered_value	SPACE 4*7 	
Failed_runs_ordered_ID		SPACE 4*7
Failed_runs_ordered_value	SPACE 4*7	

                AREA    |.text|, CODE, READONLY
; Reset Handler


Reset_Handler   PROC
                EXPORT  Reset_Handler             [WEAK]

    LDR R0, =Best_times       ; Carica l'indirizzo di Best_times
	LDR R5, =Best_times_ordered_value
	LDR R1, =Best_times_ordered_ID
	LDR R2, =Num_days
	LDR R3, [R2] ; store value of days
	MOV R4, #0 ; indx days x il primo loop

; in questo loop mi salvo nei due array valore e ID
store_array
	cmp R4, R3
	beq bsort_next
	LDR R8, [r0], #4
	STR R8, [r1], #4
    LDR R9, [r0], #4
	STR R9, [R5], #4
	add r4, r4, #1
	b store_array
	
; inizio del bubble sort
bsort_next
	MOV R6, #0 ; NUMBER OF SWAPS
	LDR R5, =Best_times_ordered_value
	LDR R1, =Best_times_ordered_ID
	MOV R4, #0 ; curr day
	
bsort_loop
	ADD R7, R4, #1 ; next day
    CMP R7, R3 ; cmp w 7
    BGE bsort_check

    ; Carica il giorno e il miglior tempo da Best_times
    LDR R8, [r5, r4, LSL #2]		  ; Carica il giorno da Best_times (ogni entry è di 8 byte
    LDR R9, [r5, r7, LSL #2]		  ; Carica il miglior tempo per il giorno
	LDR R10, [r1, r4, LSL #2]
	LDR R11, [r1, r7, LSL #2]
	
	cmp r9, r8
	bgt swap
	movlt r4,r7
	blt bsort_loop
swap
	STR R9, [r5, r4, LSL #2]		  ; Carica il giorno da Best_times (ogni entry è di 8 byte
    STR R8, [r5, r7, LSL #2]		  ; Carica il miglior tempo per il giorno
	STR R11, [r1, r4, LSL #2]
	STR R10, [r1, r7, LSL #2]
	add r6, r6, #1
	mov r4, r7
	b bsort_loop

bsort_check
	cmp r6, #0
	bgt bsort_next
	moveq r7, #6
	ldreq r12, [r1, r7, lsl #2]

upload_failed_array
	LDR R0, =Failed_runs       ; Carica l'indirizzo di Best_times
	LDR R5, =Failed_runs_ordered_value
	LDR R1, =Failed_runs_ordered_ID
	MOV R4, #0 ; indx days x il primo loop
	
store_fail_array
	cmp R4, R3
	beq bsort_next_fail
	LDR R8, [r0], #4
	STR R8, [r1], #4
    LDR R9, [r0], #4
	STR R9, [R5], #4
	add r4, r4, #1
	b store_fail_array
	
bsort_next_fail
	MOV R6, #0 ; NUMBER OF SWAPS
	LDR R5, =Failed_runs_ordered_value
	LDR R1, =Failed_runs_ordered_ID
	MOV R4, #0 ; curr day
	
bsort_loop_fail
	ADD R7, R4, #1 ; next day
    CMP R7, R3 ; cmp w 7
    BGE bsort_check_fail

    ; Carica il giorno e il miglior tempo da Best_times
    LDR R8, [r5, r4, LSL #2]		  ; Carica il giorno da Best_times (ogni entry è di 8 byte
    LDR R9, [r5, r7, LSL #2]		  ; Carica il miglior tempo per il giorno
	LDR R10, [r1, r4, LSL #2]
	LDR R11, [r1, r7, LSL #2]
	
	cmp r9, r8
	bgt swap_fail
	movlt r4,r7
	blt bsort_loop_fail
	
swap_fail
	STR R9, [r5, r4, LSL #2]		  ; Carica il giorno da Best_times (ogni entry è di 8 byte
    STR R8, [r5, r7, LSL #2]		  ; Carica il miglior tempo per il giorno
	STR R11, [r1, r4, LSL #2]
	STR R10, [r1, r7, LSL #2]
	add r6, r6, #1
	mov r4, r7
	b bsort_loop_fail

bsort_check_fail
	cmp r6, #0
	bgt bsort_next_fail
	
stop
    ; Risultati in R3 (giorni con miglior tempo >= 1300) e R10 (somma dei failed runs)
    ; Termina l'esecuzione o prosegui con altre operazioni
 	b stop
	ENDP

					LTORG
					ALIGN 2
					SPACE 4096	
Days                DCB 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07
Best_times          DCD 0x06, 1300, 0x03, 1700, 0x02, 1200, 0x04, 1900
					DCD 0x05, 1110, 0x01, 1670, 0x07, 1000
Failed_runs         DCD 0x02, 50, 0x05, 30, 0x06, 100, 0x01, 58 
					DCD 0x03, 40, 0x04, 90, 0x07, 25
Num_days           	DCB 7
Best_times_ordered 	SPACE 4*7
best_fail_ordered 	SPACE 4*7
					SPACE 4096


; Dummy Exception Handlers (infinite loops which can be modified)

NMI_Handler     PROC
                EXPORT  NMI_Handler               [WEAK]

                B       .
				
                ENDP
HardFault_Handler\
                PROC
                EXPORT  HardFault_Handler         [WEAK]
                ; your code
				orr r0,r0,#1
				mov r1, r2
				BX	r0
                ENDP
MemManage_Handler\
                PROC
                EXPORT  MemManage_Handler         [WEAK]
                B       .
                ENDP
BusFault_Handler\
                PROC
                EXPORT  BusFault_Handler          [WEAK]
                B       .
                ENDP
UsageFault_Handler\
                PROC
                EXPORT  UsageFault_Handler        [WEAK]
                B       .
                ENDP
SVC_Handler     PROC
                EXPORT  SVC_Handler               [WEAK]
                B       .
                ENDP
DebugMon_Handler\
                PROC
                EXPORT  DebugMon_Handler          [WEAK]
                B       .
                ENDP
PendSV_Handler  PROC
                EXPORT  PendSV_Handler            [WEAK]
                B       .
                ENDP
SysTick_Handler PROC
                EXPORT  SysTick_Handler           [WEAK]
                B       .
                ENDP

Default_Handler PROC

                EXPORT  WDT_IRQHandler            [WEAK]
                EXPORT  TIMER0_IRQHandler         [WEAK]
                EXPORT  TIMER1_IRQHandler         [WEAK]
                EXPORT  TIMER2_IRQHandler         [WEAK]
                EXPORT  TIMER3_IRQHandler         [WEAK]
                EXPORT  UART0_IRQHandler          [WEAK]
                EXPORT  UART1_IRQHandler          [WEAK]
                EXPORT  UART2_IRQHandler          [WEAK]
                EXPORT  UART3_IRQHandler          [WEAK]
                EXPORT  PWM1_IRQHandler           [WEAK]
                EXPORT  I2C0_IRQHandler           [WEAK]
                EXPORT  I2C1_IRQHandler           [WEAK]
                EXPORT  I2C2_IRQHandler           [WEAK]
                EXPORT  SPI_IRQHandler            [WEAK]
                EXPORT  SSP0_IRQHandler           [WEAK]
                EXPORT  SSP1_IRQHandler           [WEAK]
                EXPORT  PLL0_IRQHandler           [WEAK]
                EXPORT  RTC_IRQHandler            [WEAK]
                EXPORT  EINT0_IRQHandler          [WEAK]
                EXPORT  EINT1_IRQHandler          [WEAK]
                EXPORT  EINT2_IRQHandler          [WEAK]
                EXPORT  EINT3_IRQHandler          [WEAK]
                EXPORT  ADC_IRQHandler            [WEAK]
                EXPORT  BOD_IRQHandler            [WEAK]
                EXPORT  USB_IRQHandler            [WEAK]
                EXPORT  CAN_IRQHandler            [WEAK]
                EXPORT  DMA_IRQHandler            [WEAK]
                EXPORT  I2S_IRQHandler            [WEAK]
                EXPORT  ENET_IRQHandler           [WEAK]
                EXPORT  RIT_IRQHandler            [WEAK]
                EXPORT  MCPWM_IRQHandler          [WEAK]
                EXPORT  QEI_IRQHandler            [WEAK]
                EXPORT  PLL1_IRQHandler           [WEAK]
                EXPORT  USBActivity_IRQHandler    [WEAK]
                EXPORT  CANActivity_IRQHandler    [WEAK]

WDT_IRQHandler
TIMER0_IRQHandler
TIMER1_IRQHandler
TIMER2_IRQHandler
TIMER3_IRQHandler
UART0_IRQHandler
UART1_IRQHandler
UART2_IRQHandler
UART3_IRQHandler
PWM1_IRQHandler
I2C0_IRQHandler
I2C1_IRQHandler
I2C2_IRQHandler
SPI_IRQHandler
SSP0_IRQHandler
SSP1_IRQHandler
PLL0_IRQHandler
RTC_IRQHandler
EINT0_IRQHandler
EINT1_IRQHandler
EINT2_IRQHandler
EINT3_IRQHandler
ADC_IRQHandler
BOD_IRQHandler
USB_IRQHandler
CAN_IRQHandler
DMA_IRQHandler
I2S_IRQHandler
ENET_IRQHandler
RIT_IRQHandler
MCPWM_IRQHandler
QEI_IRQHandler
PLL1_IRQHandler
USBActivity_IRQHandler
CANActivity_IRQHandler

                B       .

                ENDP


                ALIGN


; User Initial Stack & Heap

                EXPORT  __initial_sp
                EXPORT  __heap_base
                EXPORT  __heap_limit                

                END
