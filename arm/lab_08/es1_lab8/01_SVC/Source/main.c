__attribute__((naked)) extern void call_svc();

int main(void){
	call_svc();
	
	while(1);
}