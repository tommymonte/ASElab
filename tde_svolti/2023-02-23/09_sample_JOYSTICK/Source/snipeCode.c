/* Estrarre in val (unsigned char [8 bit]) il valore dal 16 al 23 esimo bit in TC */
val = (LPC_TIM1->TC & (255 << 16)) >> 16;

/* Rappresentare sui led il valore res di 32 bit, 8 bit alla volta, partendo da LSB */
aus = ((res & (255 << (8 * position)))) >> (8 * position);

void printOnLed(int pos) {
	int binary[8];
	int i, count = 7;
	
	for(i = 0; pos > 0; i++){    
		binary[i] = pos % 2;    
		pos = pos / 2;    
	}
	
	
	for(i = 0; i < 8; i++) {
		if(binary[i] == 0)
			LED_Off(count);
		else
			LED_On(count);
		
		count --;
	}
}

//Versione alternativa 
void printOnLed(int number) {
	int resto = 0;
	int cont = 7;
	
	while(cont >= 0 && number > 0) {
		resto = number % 2;
		if(resto == 0)
			LED_Off(cont);
		else
			LED_On(cont);
		
		number = number / 2;
		
		cont --;
	}
}