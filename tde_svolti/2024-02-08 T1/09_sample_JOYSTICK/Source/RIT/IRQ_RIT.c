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

uint32_t VAR;
uint32_t VETT[6];

extern uint32_t count_tim1;
uint8_t led = 0;
extern unsigned char contatore_inrange(unsigned int VETT[], const unsigned int n);
char i = 0;

extern char new_val;
uint8_t result;

void decToBin(int val, uint8_t *buffer) {
// Caso speciale: se val = 0, restituiamo "0"
    if (val == 0) {
        buffer[0] = '0';
        buffer[1] = '\0';
        return;
    }

    int index = 0;

    // Finch? val > 0, controlliamo il resto di val / 2
    while (val > 0) {
        int bit = val % 2;      // Resto della divisione per 2 (0 o 1)
        val = val / 2;         // Aggiorna val dividendolo per 2

        // 'bit' ? 0 o 1, lo convertiamo in char '0' o '1'
        buffer[index] = (bit == 1) ? 1 : 0;
        index++;
    }
	}
	uint8_t val31_24, val23_16, val15_8, val7_0;
	uint8_t new_var;
uint8_t printToLed(uint32_t val) {
	uint8_t val31_24, val23_16, val15_8, val7_0;
	uint8_t new_var;
	
	val31_24 = (val & ( 255 << 24)) >> 24;
	val23_16 = (val & ( 255 << 16)) >> 16;
	val15_8 = (val & ( 255 << 8)) >> 8;
	val7_0 = (val & ( 255 << 0)) >> 0;
	
	new_var = (val31_24 | val23_16) ^ (val15_8 & val7_0);
	return new_var;
}

extern char max_cnt2;
extern char f_tim2;
void RIT_IRQHandler (void)
{	
	static int J_select=0;
	static int J_down = 0;
	static int J_up = 0;
	static int J_left = 0;
	static int J_right = 0;
		
	if (new_val == 1) {
		new_val = 0;
		VETT[i] = VAR;
		i++;
		if (i == 6){ // vett è saturo
			disable_timer(2);
			reset_timer(2);
			result = contatore_inrange(VETT, 6);
			enable_timer(3);
			LED_Out(result);
			disable_RIT();
	}
}
	
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
					enable_timer(1);
					if(LPC_TIM0->TC > 0){
						disable_timer(0);
					}
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
					disable_timer(1);
					reset_timer(1);
					VAR = count_tim1;
					count_tim1 = 0;
					val31_24 = (VAR & ( 255 << 24)) >> 24;
					val23_16 = (VAR & ( 255 << 16)) >> 16;
					val15_8 = (VAR & ( 255 << 8)) >> 8;
					val7_0 = (VAR & ( 255 << 0)) >> 0;
	
					new_var = (val31_24 | val23_16) ^ (val15_8 & val7_0);
					led = new_var;
					enable_timer(0);
					enable_timer(2);
					//disable_RIT();
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
	
  LPC_RIT->RICTRL |= 0x1;	/* clear interrupt flag */
	
  return;

}

/******************************************************************************
**                            End Of File
******************************************************************************/