/*********************************************************************************************************
**--------------File Info---------------------------------------------------------------------------------
** File name:           IRQ_RIT.c
** Last modified Date:  2014-09-25
** Last Version:        V1.00
** Descriptions:        functions to manage T0 and T1 interrupts
** Correlated files:    RIT.h
**--------------------------------------------------------------------------------------------------------
*********************************************************************************************************/
#include "lpc17xx.h"
#include "RIT.h"
#include "../led/led.h"
#include "../timer/timer.h"

/******************************************************************************
** Function name:		RIT_IRQHandler
**
** Descriptions:		REPETITIVE INTERRUPT TIMER handler
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/

volatile int EINT0_down=0;
volatile int EINT1_down=0;
volatile int EINT2_down=0;

uint32_t VETT[5] = {0}; // 32 bit quindi dimensione 5
uint32_t VAR = 0;

extern int count_negative_and_odd(int*, unsigned int);
unsigned int n = 5;
uint8_t i = 0;

void RIT_IRQHandler (void)
{	
	static int J_select=0;
	static int J_down = 0;
	static int J_up = 0;
	static int J_left = 0;
	static int J_right = 0;
		
	if((LPC_GPIO1->FIOPIN & (1<<25)) == 0){	// J_select
		J_select++;
		switch(J_select){
			case 1:
				
				break;
			default:
				break;
		}
	}
	else{
			J_select=0;
	}
	
	if((LPC_GPIO1->FIOPIN & (1<<26)) == 0){	// J_down
		J_down++;
		switch(J_down){
			case 1:
				VAR -= 8;
				VETT[i] = VAR;
				i++;
				break;
			default:
				break;
		}
	}
	else{
			J_down=0;
	}
	
	if((LPC_GPIO1->FIOPIN & (1<<27)) == 0){ // J_left
		J_left++;
		switch(J_left){
			case 1:
				
				break;
			default:
				break;
		}
	}
	else{
			J_left=0;
	}
	
	if((LPC_GPIO1->FIOPIN & (1<<28)) == 0){	//J_right
		J_right++;
		switch(J_right){
			case 1:
				
				break;
			default:
				break;
		}
	}
	else{
			J_right=0;
	}
	
	if((LPC_GPIO1->FIOPIN & (1<<29)) == 0){	// J_up
		J_up++;
		switch(J_up){
			case 1:
				VAR += 12;
				VETT[i] = VAR;
				i++;
				break;
			default:
				break;
		}
	}
	else{
			J_up=0;
	}
	
	/* button management */
	if(EINT0_down!=0){ 
		if((LPC_GPIO2->FIOPIN & (1<<10)) == 0){	/* EINT0 pressed */
			EINT0_down++;				
			switch(EINT0_down){
				case 2:
					
					break;
				default:
					break;
			}
		}
		else {	/* button released */
			EINT0_down=0;			
			NVIC_EnableIRQ(EINT0_IRQn);							 /* enable Button interrupts			*/
			LPC_PINCON->PINSEL4    |= (1 << 20);     /* External interrupt 0 pin selection */
		}
	}
	
	if(EINT1_down!=0){ 
		if((LPC_GPIO2->FIOPIN & (1<<11)) == 0){	/* EINT1 pressed */
			EINT1_down++;				
			switch(EINT1_down){
				case 2:
					
					break;
				default:
					break;
			}
		}
		else {	/* button released */
			EINT1_down=0;			
			NVIC_EnableIRQ(EINT1_IRQn);							 /* enable Button interrupts			*/
			LPC_PINCON->PINSEL4    |= (1 << 22);     /* External interrupt 0 pin selection */
		}
	}
	
	if(EINT2_down!=0){ 
		if((LPC_GPIO2->FIOPIN & (1<<12)) == 0){	/* EINT2 pressed */
			EINT2_down++;				
			switch(EINT2_down){
				case 2:
					
					break;
				default:
					break;
			}
		}
		else {	/* button released */
			EINT2_down=0;			
			NVIC_EnableIRQ(EINT2_IRQn);							 /* enable Button interrupts			*/
			LPC_PINCON->PINSEL4    |= (1 << 24);     /* External interrupt 0 pin selection */
		}
	}
	
	if (i==n) {
		
	
  LPC_RIT->RICTRL |= 0x1;	/* clear interrupt flag */
	
  return;

}

/******************************************************************************
**                            End Of File
******************************************************************************/