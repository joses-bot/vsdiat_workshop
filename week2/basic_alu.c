#include <stdio.h>

int alu(int operandA, int operandB, int instruction_type) ;

int main()
{
int ii,jj;
int result;

printf("\nBasic ALU\n");

for (ii = 10; ii <11; ii++)
for (jj =  8; jj <9; jj++)
{
result = alu(ii,jj,0);
printf("\nSUM %d  %d  = %d\n",ii,jj, result);
result = alu(ii,jj,1);
printf("\nSUBS %d  %d  = %d\n",ii,jj, result);
result = alu(ii,jj,2);
printf("\nMUL %d  %d  = %d\n",ii,jj, result);
result = alu(ii,jj,3);
printf("\nDIV %d  %d  = %d\n",ii,jj, result);
result = alu(ii,jj,4);
printf("\nAND %d  %d  = %d\n",ii,jj, result);
result = alu(ii,jj,5);
printf("\nOR %d  %d  = %d\n",ii,jj, result);
}

return 0;
}


int alu(int operandA, int operandB, int instruction_type) 
{

int result;

switch (instruction_type) {
  case 0: 
       result = operandA + operandB;
       break;

  case 1: 
       result = operandA - operandB;
        break;

  case 2: 
       result = operandA * operandB;
        break;

  case 3: 
       result = operandA / operandB;
       break;

  case 4: 
       result = operandA & operandB;
       break;

  case 5: 
       result = operandA | operandB;
       break;

}


return (result);
}
