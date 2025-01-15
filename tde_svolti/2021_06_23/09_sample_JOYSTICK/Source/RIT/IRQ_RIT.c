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
extern char led_value;
extern unsigned int sopra_la_media(unsigned char VETT[], unsigned int n);
int flag4 = 0;
int internal_flag = 0;

void intToBin(char buffer[8], unsigned char value){
	for (int i = 7; i>=0; i--){
		if (value%2==0) {
			buffer[i] = '0';
		} else {
			buffer[i] = '1';
	}
		value = value/2;
}
}	

void binToLed(char buffer[8]){
	for (int i = 8; i>=0; i--){
		if (buffer[i] == '1') {
			LED_On(7-i);
		} else {
			LED_Off(7-i);
	}
}
	}

unsigned char VAR = 0;
unsigned char VETT[8] = {0};
unsigned int n;
uint8_t cnt = 0;
unsigned int risultato;
	
void RIT_IRQHandler (void)
{					
	static int J_select=0;
	static int J_up = 0;
	static int J_left = 0;

	char buffer[8];
	
	if((LPC_GPIO1->FIOPIN & (1<<25)) == 0){	// J_select
		J_select++;
		switch(J_select){
			case 50:
					VAR = 0;
				break;
			default:
				break;
		}
	}
	else{
			J_select=0;
	}
	
	if((LPC_GPIO1->FIOPIN & (1<<27)) == 0){ // J_left
		J_left++;
		switch(J_left){
			case 50:
				if (VAR == 0){
					VAR = 0;
				} else {
					VAR--;
				}
				
				break;
			default:
				break;
		}
	}
	else{
			J_left=0;
	}
	
	if((LPC_GPIO1->FIOPIN & (1<<29)) == 0){	// J_up
		J_up++;
		switch(J_up){
			case 50:
				if (VAR == 255){
					VAR = 255;
				} else {
					VAR++;
				}
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
					if (cnt < 8) {
					VETT[cnt] = VAR;
					VAR = 0;
					}
					cnt++;
					n = cnt;
					
					if(cnt >= 8) {
						risultato = sopra_la_media(VETT, n);
						flag4 = 1;
					}
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
	
	intToBin(buffer, VAR);
	binToLed(buffer);
	
	if (flag4 == 1){
		
		if (risultato > 8){
			if (internal_flag == 0){
				LED_Off(0xFF);
				LED_On(0xAA);
				internal_flag = 1;
			} else {
				LED_Off(0xFF);
				LED_On(0x55);
				internal_flag = 0;
			}
	} else {
		LED_On(risultato);
	}
}
  LPC_RIT->RICTRL |= 0x1;	/* clear interrupt flag */
	
  return;
}

/******************************************************************************
**                            End Of File
******************************************************************************/