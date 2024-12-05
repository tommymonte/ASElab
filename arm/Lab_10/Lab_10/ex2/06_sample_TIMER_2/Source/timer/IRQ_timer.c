/*********************************************************************************************************
**--------------File Info---------------------------------------------------------------------------------
** File name:           IRQ_timer.c
** Last modified Date:  2014-09-25
** Last Version:        V1.00
** Descriptions:        functions to manage T0 and T1 interrupts
** Correlated files:    timer.h
**--------------------------------------------------------------------------------------------------------
*********************************************************************************************************/
#include "LPC17xx.h"
#include "timer.h"
#include "../led/led.h"
#define BUFFER_SIZE 7000
#define CLEAN_PATTERN 0xCAFECAFE
/******************************************************************************
** Function name:		Timer0_IRQHandler
**
** Descriptions:		Timer/Counter 0 interrupt handler
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/
extern unsigned char led_value;					/* defined in funct_led								*/

unsigned char ledval = 0xA5;


void TIMER0_IRQHandler (void)
{
  return;
}

/******************************************************************************
** Function name:		Timer1_IRQHandler
**
** Descriptions:		Timer/Counter 1 interrupt handler
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/
extern uint32_t circular_buffer[BUFFER_SIZE];
extern uint16_t buffer_index;  // Indice per il buffer circolare

void TIMER1_IRQHandler(void) {
    if (LPC_TIM1->IR & 1) {  // MR0 interrupt
        LPC_TIM1->IR = 1;  // Pulisci il flag di interruzione

        // Leggi il valore corrente del contatore di TIMER0
        uint32_t timer0_value = LPC_TIM0->TC;

        // Salva il valore nel buffer circolare
        circular_buffer[buffer_index] = timer0_value;

        // Incrementa l'indice del buffer
        buffer_index = (buffer_index + 1) % BUFFER_SIZE;
    }
}

/******************************************************************************
** Function name:		Timer2_IRQHandler
**
** Descriptions:		Timer/Counter 1 interrupt handler
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/
void TIMER2_IRQHandler(void) {
    if (LPC_TIM2->IR & 1) {  // MR0 interrupt (timer reached MR0)
        LPC_TIM2->IR = 1;  // Clear interrupt flag
        LED_Off(1);  // Turn off the LED when MR0 is reached
    }
    else if (LPC_TIM2->IR & 2) {  // MR1 interrupt (timer reached MR1)
        LPC_TIM2->IR = 2;  // Clear interrupt flag
        LED_On(1);  // Turn on the LED when MR1 is reached
    }
}
/******************************************************************************
** Function name:		Timer2_IRQHandler
**
** Descriptions:		Timer/Counter 1 interrupt handler
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/
void TIMER3_IRQHandler(void) {
    if (LPC_TIM3->IR & 1) {  // MR0 interrupt (timer reached MR0)
        LPC_TIM3->IR = 1;  // Clear interrupt flag
        LED_Off(0);  // Turn off the LED when MR0 is reached
    }
    else if (LPC_TIM3->IR & 2) {  // MR1 interrupt (timer reached MR1)
        LPC_TIM3->IR = 2;  // Clear interrupt flag
        LED_On(0);  // Turn on the LED when MR1 is reached
    }
}

/******************************************************************************
**                            End Of File
******************************************************************************/