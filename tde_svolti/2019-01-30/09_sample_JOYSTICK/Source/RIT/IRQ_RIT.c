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

uint8_t f = 0;
int e1 = 0;
int e2 = 0;

extern int divisible(int, int);
int countdown = 0;
char flag_timer2 = 0;
int result = 0;
// Converte 'val' in una stringa di 4 bit (LSB->MSB, poi invertiti)
void decToBin(int val, uint8_t *buffer) {
// Caso speciale: se val = 0, restituiamo "0"
    if (val == 0) {
        buffer[0] = '0';
        buffer[1] = '\0';
        return;
    }

    int index = 0;

    // Finché val > 0, controlliamo il resto di val / 2
    while (val > 0) {
        int bit = val % 2;      // Resto della divisione per 2 (0 o 1)
        val = val / 2;         // Aggiorna val dividendolo per 2

        // 'bit' è 0 o 1, lo convertiamo in char '0' o '1'
        buffer[index] = (bit == 1) ? 1 : 0;
        index++;
    }
	}

void binToLED(uint8_t *buffer, int led_start, int led_end){
	for (int i = led_start;i<=led_end; i++){
		if (buffer[i - 4] == 1) {
			LED_On(i);
		} else {
			LED_Off(i);
		}
	}
}

void binToLED4(uint8_t *buffer, int led_start, int led_end){
	for (int i = led_start;i<=led_end; i++){
		if (buffer[i] == 1) {
			LED_On(i);
		} else {
			LED_Off(i);
		}
	}
}

uint8_t buffer_e1[4];
uint8_t buffer_result[4];

void RIT_IRQHandler (void)
{	
	/* button management */
	if(EINT0_down!=0){ 
		if((LPC_GPIO2->FIOPIN & (1<<10)) == 0){	/* EINT0 pressed */
			EINT0_down++;				
			switch(EINT0_down){
				case 2:
					if(f == 0) {
							enable_timer(2); // abilita il timer
							f = 1;
							flag_timer2 = 1;
					} else if (f == 1){
							reset_timer(2);
							e1 = 0;
							e2 = 0;
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
	
	if(EINT1_down!=0){ 
		if((LPC_GPIO2->FIOPIN & (1<<11)) == 0){	/* EINT1 pressed */
			EINT1_down++;				
			switch(EINT1_down){
				case 2:
					if (flag_timer2 == 1) {
						e1++;
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
					if (flag_timer2 == 1) {
						e2++;
					}
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
	

	if (flag_timer2 == 2) {
		decToBin(e1, buffer_e1);
		binToLED(buffer_e1, 4 , 7);
		result = divisible(e1, e2);
		decToBin(result, buffer_result);
		binToLED4(buffer_result, 0, 3);
		disable_RIT();
	}
	
  LPC_RIT->RICTRL |= 0x1;	/* clear interrupt flag */
	
  return;

}

/******************************************************************************
**                            End Of File
******************************************************************************/