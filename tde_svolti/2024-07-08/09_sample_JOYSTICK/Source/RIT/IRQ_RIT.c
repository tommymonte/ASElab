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

unsigned char VETT[4] = {35, 42, 68, 20}; 
unsigned char VETT2[4] = {0};
char RES[4] = {0};

extern unsigned char analisi_accuratezza(unsigned char VETT[], unsigned char VETT2[], const unsigned int N, char RES[]);
unsigned char average;
uint8_t buffer[8] = {0};
uint8_t res_buffer[8];
unsigned char i = 0;
unsigned char flag = 0;
unsigned char z = 0;
unsigned char skip = 0;
extern unsigned char led_state;
unsigned char new_val = 0;
unsigned char curr_vett = 0, curr_vett2 = 0;
unsigned char maxcnt, period, res;

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

void printToLed(uint8_t* buffer, char N) {
	for(int i = 0; i<N; i++) {
		if (buffer[i] == 1) {
			LED_Off(i);
		} else {
			LED_On(i);
		}
	}
}


void RIT_IRQHandler (void)
{	
	static int J_select=0;
	static int J_down = 0;
	static int J_up = 0;
	static int J_left = 0;
	static int J_right = 0;
	
	if (z == 4) {
		z = 0;
		skip = 0;
		new_val = 0;
	}
	
	if (skip == 0){
	
	if(EINT1_down!=0){ 
		if((LPC_GPIO2->FIOPIN & (1<<11)) == 0){	/* EINT1 pressed */
			EINT1_down++;				
			switch(EINT1_down){
				case 2:
					curr_vett = VETT[i];
					LED_Out(curr_vett);
					flag = 1; // button is pressed
					enable_timer(0);
					enable_timer(1);
					break;
				
				case 10: // dopo 500 ms spengo i led
					LED_Out(0);
					break; 
				default:
					break;
			}
		}
		else {	/* button released */
			EINT1_down=0;			
			if (flag == 1) { // button was pressed
					flag = 2;			
			}
			NVIC_EnableIRQ(EINT1_IRQn);							 /* enable Button interrupts			*/
			LPC_PINCON->PINSEL4    |= (1 << 22);     /* External interrupt 0 pin selection */
		}
	}
	
}
	
	
	if (i == 4) {
		skip = 1; // saturazione --> non devo prendere più valori
		average = analisi_accuratezza(VETT, VETT2, 4, RES);
		i = 0;
		new_val = 1; // posso analizzare un nuovo valore
	}
	
	if (new_val == 1) { 
		new_val = 0; // lo riporto a 0 finchè non ho processato l'i-esimo valore
		
		if (RES[z] <= average){
			maxcnt = 20;
			period = 5;
		} else if (RES[z] > average) {
			maxcnt = 10;
			period = 2;
		}
		res = RES[z];
		enable_timer(2);
	}

		
  LPC_RIT->RICTRL |= 0x1;	/* clear interrupt flag */
	
  return;

}

/******************************************************************************
**                            End Of File
******************************************************************************/