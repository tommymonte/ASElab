extern int  Matrix_Coordinates;
extern char  ROWS;
extern char  COLUMNS;

extern float my_division(float* a, float* b);
extern int check_square(int x, int y, int r);

#define RADIUS 5

int main(void){
	int rows = ROWS;
	int columns = COLUMNS;
	int *matrix = &Matrix_Coordinates;
	int i, x, y;
	float a = 0, denominator;
	volatile float pi = 0;
	
	for(i = 0; i < rows * columns; i += 2){
			x = matrix[i];
			y = matrix[i + 1];
		
			a += check_square(x, y, RADIUS);
	}
	
	denominator = RADIUS * RADIUS;
	pi = my_division ((float*) &a, &denominator);
		
	while(1);
}
