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

unsigned char acquisizione = 0;
unsigned char not_acquisizione = 1; // monitor
uint32_t tempi_variazioni[5] = {0}; // 32 bit quindi dimensione 5
uint32_t valore_iniziale;
char state = 0;
extern char duty_cycle(uint8_t, uint32_t, uint32_t *, uint8_t);
extern uint32_t tempo_totale;
char dutycycle;
uint8_t variazioni;

void RIT_IRQHandler (void)
{					
	static int J_select=0;
	static int J_up = 0;
	static int J_left = 0;
	
	// modalità acquisizione
	if (acquisizione == 1) {
		LED_Out(255);
	} 
	
	// modalità monitor
	else {
		enable_timer(1);
		dutycycle = duty_cycle(valore_iniziale, tempo_totale, tempi_variazioni, variazioni);
	}
		
	if(EINT2_down!=0){ 
		if((LPC_GPIO2->FIOPIN & (1<<12)) == 0){	/* EINT2 pressed */
			EINT2_down++;				
			switch(EINT2_down){
				case 2:
					not_acquisizione = 0;
					acquisizione = 1;
					enable_timer(3);
					valore_iniziale = !(LPC_GPIO1->FIOPIN & (1<<29)); // campiono il valore iniziale del joystick
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