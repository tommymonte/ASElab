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
extern uint8_t variazioni;
extern tempi_variazioni[5];
uint32_t tempo_totale;
extern char dutycycle;
void TIMER0_IRQHandler (void)
{
	// campiono il joystick
	if((LPC_GPIO1->FIOPIN & (1<<29))){
			tempi_variazioni[variazioni] = LPC_TIM3->TC; // salvo il tempo a cui arriva l'interrupt sul joystick
			variazioni++;
			if(variazioni >= 5){ // se ho fatto più di 5 transizioni disabilito i timer e salvo il tempo totale
				disable_timer(0);
				disable_timer(3);
				tempo_totale = LPC_TIM3->TC;
				reset_timer(2);
				reset_timer(3);
	}
}
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

char switch_led = 0;

void TIMER1_IRQHandler (void)
{	
	if (switch_led) {
		// num variazioni
		LED_Off(255);
		LED_On(7);
		LED_Out(dutycycle);
		switch_led = 1;
	}
	else {
		switch_led = 0;
		LED_Off(255);
		LED_Out(variazioni);
	}
  LPC_TIM1->IR = 1;			/* clear interrupt flag */
  return;
}

extern not_acquisizione;
extern acquisizione;

void TIMER3_IRQHandler (void)
{	
	enable_timer(0);
	tempo_totale = 25000000;
	
	// alla fine riporto il sistema in modalità monitor
	not_acquisizione = 1;
	acquisizione = 0;
	
  LPC_TIM3->IR = 1;			/* clear interrupt flag */
  return;
}
/******************************************************************************
**                            End Of File
******************************************************************************/
