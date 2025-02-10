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
unsigned int count_tim0 = 0;
extern unsigned char curr_vett, curr_vett2;
extern char i;

void TIMER0_IRQHandler (void)
{
	unsigned char temp_count = count_tim0;
	if(temp_count >= curr_vett){
		disable_timer(0);
		reset_timer(0);
	} else {
		count_tim0++;
	}
  LPC_TIM0->IR = 1;			/* clear interrupt flag */
  return;
}
int count_tim1 = 0;
extern unsigned char flag;
extern unsigned char VETT2[4];
void TIMER1_IRQHandler (void)
{	
	if(flag == 2) { // button released
		disable_timer(1);
		reset_timer(1);
		flag = 0;
		curr_vett2 = count_tim1;
		VETT2[i] = curr_vett2;
		count_tim1 = 0;
		count_tim0 = 0;
		i++;
	}
		else { 
			count_tim1++;
	}
  LPC_TIM1->IR = 1;			/* clear interrupt flag */
  return;
}

int count_tim2 = 0;
int max_tim2 = 0;
extern char new_val;
extern char z;
extern char maxcnt, period;
char led_state = 0;
extern unsigned char res;

void TIMER2_IRQHandler (void)
{	
	if (max_tim2 >= maxcnt) {
		z++;
		new_val = 1;
		count_tim2 = 0;
		max_tim2 = 0;
		disable_timer(2);
		reset_timer(2);
	}
	else {
		if (count_tim2 <= period) {
			LED_Out(res);
		} else if (count_tim2 > period && count_tim2 <= period*2){
			LED_Out(0);
			count_tim2 = 0;
		}
		count_tim2++;
		max_tim2++;
	}
		LPC_TIM2->IR = 1;			/* clear interrupt flag */
  return;
}

/******************************************************************************
**                            End Of File
******************************************************************************/
