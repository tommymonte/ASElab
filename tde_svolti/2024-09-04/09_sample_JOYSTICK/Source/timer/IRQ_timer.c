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

/******************************************************************************
** Function name:		Timer0_IRQHandler
**
** Descriptions:		Timer/Counter 0 interrupt handler
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/
int count_tim0 = 0;
void TIMER0_IRQHandler (void)
{
	if(count_tim0<7) {
		LED_On(6);
		}
	else {
		LED_Off(6);
	}
	
	if (count_tim0 == 14) {
		count_tim0 = 0;
	}

	count_tim0++;
  LPC_TIM0->IR = 1;			/* clear interrupt flag */
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
int count_tim1 = 0;
int count_tim2 = 0;
extern uint32_t VAR;

void TIMER1_IRQHandler (void)
{	
	count_tim1++;
	if(count_tim1 == 17) {
		VAR = LPC_TIM2->TC;
		count_tim1 = 0;
	}
  LPC_TIM1->IR = 1;			/* clear interrupt flag */
  return;
}

void TIMER2_IRQHandler (void)
{	
	count_tim2++;
	if(count_tim2 == 146) {
		disable_timer(1);
		disable_timer(2);
	}
  LPC_TIM2->IR = 1;			/* clear interrupt flag */
  return;
}
/******************************************************************************
**                            End Of File
******************************************************************************/
