#include "button.h"
#include "LPC17xx.h"


#include "../led/led.h"
#include "../timer/timer.h"

#define BUFFER_SIZE 7000
#define CLEAN_PATTERN 0xCAFECAFE

extern volatile uint32_t circular_buffer[BUFFER_SIZE];
extern volatile uint32_t buffer_index;  // Posizione corrente nel buffer

void bubble_sort(volatile uint32_t *buffer, uint32_t size) {
    for (uint32_t i = 0; i < size - 1; i++) {
        for (uint32_t j = 0; j < size - i - 1; j++) {
            if (buffer[j] > buffer[j + 1]) {
                uint32_t temp = buffer[j];
                buffer[j] = buffer[j + 1];
                buffer[j + 1] = temp;
            }
        }
    }
}

uint32_t compute_average(volatile uint32_t *buffer, uint32_t size) {
    uint64_t sum = 0;
    for (uint32_t i = 0; i < size; i++) {
        sum += buffer[i];
    }
    return sum / size;
}

void clean_buffer(volatile uint32_t *buffer, uint32_t size) {
    for (uint32_t i = 0; i < size; i++) {
        buffer[i] = CLEAN_PATTERN;
    }
}

void EINT1_IRQHandler(void) {

		/*disable_timer(1);
    // Step 1: Ordinamento del buffer
    bubble_sort(circular_buffer, BUFFER_SIZE);

    // Step 2: Calcolo della media
    uint32_t average = compute_average(circular_buffer, BUFFER_SIZE);
		*/
	
		disable_timer(1);
    // Step 3: Pulizia del buffer
    clean_buffer(circular_buffer, BUFFER_SIZE);

		LPC_SC->EXTINT &= (1 << 1);     /* clear pending interrupt         */
}

void EINT0_IRQHandler (void)	  	/* INT0														 */
{
	LPC_SC->EXTINT &= (1 << 0);     /* clear pending interrupt         */
}

void EINT2_IRQHandler (void)	  	/* KEY2														 */
{
	LPC_SC->EXTINT &= (1 << 2);     /* clear pending interrupt         */  
	enable_timer(0);  
}


