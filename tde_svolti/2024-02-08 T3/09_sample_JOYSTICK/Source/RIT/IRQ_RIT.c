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

#define N 9

volatile int EINT0_down=0;
volatile int EINT1_down=0;
volatile int EINT2_down=0;

unsigned char VETT[N] = {1,1,1,2,0,1,3,2};
unsigned char VETT2[N];
uint8_t index = 0; // uso un indice per gestire il vettore
char f1=0, f2=0;
unsigned char process_done = 0;
extern unsigned int compare(unsigned char VETT[], unsigned char VETT2[], const unsigned int n);

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

unsigned int result = 0;
	
void RIT_IRQHandler (void)
{	
	static int J_select=0;
	static int J_down = 0;
	static int J_up = 0;
	static int J_left = 0;
	static int J_right = 0;
	
	if(process_done==1){
		result = compare(VETT, VETT2, N);
		process_done = 2;
		enable_timer(1);
	}
	else if (process_done == 2) {
		if((LPC_GPIO1->FIOPIN & (1<<29)) == 0){	// J_up
		J_up++;
		switch(J_up){
			case 1:
				LED_Out(0);
				disable_timer(1);
				reset_timer(1);
				process_done = 0;
				for (int i = 0; i<N; i++){
					VETT2[i] = 0;
				}
				index = 0;
				break;
			default:
				break;
		}
	}
	else{
			J_up=0;
	}
		
	}
	else if (process_done == 0){
		
	if (VETT[index] == 1) {
		LED_On(6);
		LED_Off(7);
	} else if (VETT[index] == 2){
		LED_Off(6);
		LED_On(7);
	} else {
		LED_Out(0);
	}
	
	/* button management */
	if(EINT1_down!=0){ 
		if((LPC_GPIO2->FIOPIN & (1<<11)) == 0){	/* EINT1 pressed */
			EINT1_down++;				
			switch(EINT1_down){
				case 2:
				VETT2[index] = 1;	
				index++;
				disable_RIT();
				enable_timer(0);
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
				VETT2[index] = 2;	
				index++;	
				disable_RIT();
				enable_timer(0);
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
	
	if (index == N) {
		LED_Out(0);
		enable_timer(3);
		disable_RIT();
	}
}
	
  LPC_RIT->RICTRL |= 0x1;	/* clear interrupt flag */
	
  return;

}

/******************************************************************************
**                            End Of File
******************************************************************************/