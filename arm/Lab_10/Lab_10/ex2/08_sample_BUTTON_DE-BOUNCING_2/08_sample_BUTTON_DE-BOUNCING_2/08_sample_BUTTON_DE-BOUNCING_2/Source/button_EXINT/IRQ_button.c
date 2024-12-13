#include "button.h"
#include "LPC17xx.h"

//	#include "../led/led.h" 					/* do not needed anymore, make your project clean */
#include "../RIT/RIT.h"		  			/* you now need RIT library 			 */
#include "../timer/timer.h"

extern int down_0;
extern int down_1;
extern int down_2;


void EINT0_IRQHandler (void)	  	/* INT0														 */
{	

	down_0 = 1;
	NVIC_DisableIRQ(EINT0_IRQn);		/* disable Button interrupts			 */
	LPC_PINCON->PINSEL4    &= ~(1 << 20);     /* GPIO pin selection */
	LPC_SC->EXTINT &= (1 << 0);     /* clear pending interrupt         */

}


void EINT1_IRQHandler (void)	  	/* KEY1														 */
{
	/*	
	NVIC_SetPriority(TIMER0_IRQn, 3);
	NVIC_SetPriority(TIMER1_IRQn, 3);
	NVIC_SetPriority(TIMER2_IRQn, 3);
	NVIC_SetPriority(TIMER3_IRQn, 3);
	*/
	disable_timer(1);
	down_1 = 1;
	NVIC_DisableIRQ(EINT1_IRQn);		/* disable Button interrupts			 */
	LPC_PINCON->PINSEL4    &= ~(1 << 22);     /* GPIO pin selection */
	LPC_SC->EXTINT &= (1 << 1);     /* clear pending interrupt         */
}

void EINT2_IRQHandler (void)	  	/* KEY2														 */
{
	down_2 = 1;
	NVIC_DisableIRQ(EINT2_IRQn);		/* disable Button interrupts			 */	
	LPC_PINCON->PINSEL4    &= ~(1 << 24);     /* GPIO pin selection */
  LPC_SC->EXTINT &= (1 << 2);     /* clear pending interrupt         */    
}


