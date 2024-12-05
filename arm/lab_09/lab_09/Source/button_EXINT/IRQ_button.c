#include "button.h"
#include "lpc17xx.h"

#include "../led/led.h"

unsigned char led_value = 0x2B;
unsigned char new_state = 0x0;
unsigned char taps = 0x15;
int output_bit = 0;
int cont=0;
extern unsigned char next_state(unsigned char led_value, unsigned char taps, int* output_bit);

void EINT0_IRQHandler (void)	  
{
	led_value = next_state(led_value,taps, &output_bit);
  LED_Out(led_value);
  LPC_SC->EXTINT &= (1 << 0);     /* clear pending interrupt         */
}


void EINT1_IRQHandler (void)	  
{
  LED_Out(led_value);
	LPC_SC->EXTINT &= (1 << 1);     /* clear pending interrupt         */
}

void EINT2_IRQHandler (void)	  
{
	unsigned char copy = led_value;
	do{
		led_value = next_state(led_value,taps, &output_bit);
		LED_Out(led_value);
	}while(led_value != copy);
  LPC_SC->EXTINT &= (1 << 2);     /* clear pending interrupt         */    
}


