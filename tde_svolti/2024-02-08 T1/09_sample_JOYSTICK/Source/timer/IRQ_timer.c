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
extern uint8_t led;
char flag_state = 0;
void TIMER0_IRQHandler (void)
{
	if (flag_state == 0){
		flag_state = 1;
		LED_Out(led);
	}
	else if (flag_state == 1){
		flag_state = 0;
		LED_Out(~led);
	}
	LPC_TIM0->IR = 1;			/* clear interrupt flag */
  return;
}

extern uint32_t VAR;
uint32_t count_tim1 = 0;

void TIMER1_IRQHandler (void)
{	
	count_tim1++;
  LPC_TIM1->IR = 1;			/* clear interrupt flag */
  return;
}

char cnt_tim2 = 0;
char new_val = 0;
char max_cnt2 = 5;
char f_tim2 = 0;
extern uint8_t result;
void TIMER2_IRQHandler (void)
{	
		if (cnt_tim2 == max_cnt2){ // hoi contato 5 secondi
			new_val = 1;	// acquisisco VAR
			cnt_tim2 = 0;
	}
		else {
			cnt_tim2++; // senno conto
		}

  LPC_TIM2->IR = 1;			/* clear interrupt flag */
  return;
}

void TIMER3_IRQHandler (void)
{
	LED_Out(0);
	disable_timer(3);
	reset_timer(3);
	enable_RIT();
	
  LPC_TIM3->IR = 1;			/* clear interrupt flag */
  return;
}
/******************************************************************************
**                            End Of File
******************************************************************************/
