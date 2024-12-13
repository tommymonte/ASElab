/*----------------------------------------------------------------------------
 * Name:    sample.c
 * Purpose: to control led through EINT buttons and manage the bouncing effect
 *        	- key1 switches on the led at the left of the current led on, 
 *					- it implements a circular led effect. 	
  * Note(s): this version supports the LANDTIGER Emulator
 * Author: 	Paolo BERNARDI - PoliTO - last modified 15/12/2020
 *----------------------------------------------------------------------------
 *
 * This software is supplied "AS IS" without warranties of any kind.
 *
 * Copyright (c) 2017 Politecnico di Torino. All rights reserved.
 *----------------------------------------------------------------------------*/
                  
#include <stdio.h>
#include "LPC17xx.h"                    /* LPC17xx definitions                */
#include "led/led.h"
#include "button_EXINT/button.h"
#include "RIT/RIT.h"
#include "timer/timer.h"

/* Led external variables from funct_led */
extern unsigned char led_value;					/* defined in funct_led								*/
#ifdef SIMULATOR
extern uint8_t ScaleFlag; // <- ScaleFlag needs to visible in order for the emulator to find the symbol (can be placed also inside system_LPC17xx.h but since it is RO, it needs more work)
#endif
/*----------------------------------------------------------------------------
  Main Program
 *----------------------------------------------------------------------------*/
#define BUFFER_SIZE 7000
#define CLEAN_PATTERN 0xCAFECAFE
volatile uint32_t circular_buffer[BUFFER_SIZE];
volatile uint16_t buffer_index = 0;  // Posizione corrente nel buffer

int main (void) {
  	
	SystemInit();  												/* System Initialization (i.e., PLL)  */
  LED_init();                           /* LED Initialization                 */
  BUTTON_init();												/* BUTTON Initialization    	*/
	LPC_SC -> PCONP |= (1 << 20);  // TURN ON TIMER 0
	LPC_SC -> PCONP |= (1 << 21);  // TURN ON TIMER 1	
	LPC_SC -> PCONP |= (1 << 22);  // TURN ON TIMER 2
	LPC_SC -> PCONP |= (1 << 23);  // TURN ON TIMER 3	
	
	
	init_RIT(0x004C4B40);									/* RIT Initialization 50 msec       */
	enable_RIT();										/* enable RIT to count 50ms				 */
	
	LED_On(0);
	init_timer(0, 0, 0, 0, 0); //MR0
	enable_timer(0);
	
	init_timer(1, 0, 0, 3, 0xA); //MR0
	enable_timer(1);
	
	init_timer(2, 0, 0, 1, 0xFA); //MR0
	init_timer(2, 0, 1, 3, 0x3E8); //MR1
	enable_timer(2);
	
	init_timer(3, 0, 0, 1, 0x3D090); //MR0
	init_timer(3, 0, 1, 3, 0xF4240); //MR1
	enable_timer(3);

	LPC_SC->PCON |= 0x1;									/* power-down	mode										*/
	LPC_SC->PCON &= ~(0x2);						
		
  while (1) {                           /* Loop forever                       */	
		__ASM("wfi");
  }

}
