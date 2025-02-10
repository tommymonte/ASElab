/*********************************************************************************************************
**--------------File Info---------------------------------------------------------------------------------
** File name:           IRQ_timer.c
** Last modified Date:  2014-09-25
** Last Version:        V1.00
** Descriptions:        functions to manage T0 and T1 interrupts
** Correlated files:    timer.h
**--------------------------------------------------------------------------------------------------------
*********************************************************************************************************/
#include <string.h>
#include "LPC17xx.h"
#include "timer.h"
#include "../GLCD/GLCD.h" 
#include "../TouchPanel/TouchPanel.h"
#include <stdio.h> /*for sprintf*/
#include "../led/led.h"
#include "../button_EXINT/button.h"

/******************************************************************************
** Function name:		Timer0_IRQHandler
**
** Descriptions:		Timer/Counter 0 interrupt handler
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/

// genera un interrupt ogni 0.25 quindi
// 0.25 * 4 allora avrò 1s mi fermo.
int count_tim0 = 0;
char state = 0; // uso una variabile di stato per gestire il blink dei led ogni 0.25s
void TIMER0_IRQHandler (void)
{
	// ho fatto 1 s
	if (count_tim0 == 4) {
		LED_Out(0);
		disable_timer(0);
		reset_timer(0);
		count_tim0 = 0;
		enable_RIT();
	} else {	// senno conto
		count_tim0++;
		if (state == 0){
			state = 1;
			LED_Out(255);
		} else if (state ==1) {
			state = 0;
			LED_Out(0);
	}
}
  LPC_TIM0->IR = 1;			/* clear interrupt flag */
  return;
}
	
extern unsigned int result;
void TIMER1_IRQHandler (void)
{
	LED_Out(result);
  LPC_TIM1->IR = 1;			/* clear interrupt flag */
  return;
}

int cnt_tim3=0;
char state3 = 0;
extern unsigned char process_done;
void TIMER3_IRQHandler (void)
{	
	if (cnt_tim3 == 24) {
		process_done = 1;
		disable_timer(3);
		reset_timer(3);
		cnt_tim3 = 0;
		enable_RIT();
	} else {
		cnt_tim3++;
		if (state3 == 0){
			LED_Out(255);
			state3 = 1;
		} else if (state3 == 1){
			LED_Out(0);
			state3 = 0;
		}
	}
  LPC_TIM3->IR = 1;			/* clear interrupt flag */
  return;
}
/******************************************************************************
**                            End Of File
******************************************************************************/
