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
int count_tim0 = 0;
void TIMER0_IRQHandler (void)
{
	if (count_tim0 == 0) {
		LED_Out(0xFF);
		count_tim0 = 1;
	} else {
		LED_Out(0x00);
		count_tim0 = 0;
	}
  LPC_TIM0->IR = 1;			/* clear interrupt flag */
  return;
}
	
void TIMER1_IRQHandler (void)
{	
	disable_timer(0);
	reset_timer(0);
	disable_timer(1);
	reset_timer(1);
	NVIC_EnableIRQ(EINT1_IRQn);   
  LPC_TIM1->IR = 1;			/* clear interrupt flag */
  return;
}

void TIMER2_IRQHandler (void)
{	
	disable_timer(3);
	reset_timer(3);
	disable_timer(2);
	reset_timer(2);
  LPC_TIM2->IR = 1;			/* clear interrupt flag */
  return;
}
extern int cnt;
char flag3 = 0;
void TIMER3_IRQHandler (void)
{	
	if (flag3 == 0){
		for (int i = 0; i<cnt ; i++){
			LED_On(i);
		}
		flag3 = 1;
	}
	else {
			LED_Out(0x00);
		flag3 = 0;
		}
  LPC_TIM3->IR = 1;			/* clear interrupt flag */
  return;
}
/******************************************************************************
**                            End Of File
******************************************************************************/
