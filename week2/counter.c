#include <stdio.h>
int main() {
  int nn, pp;
  int counter = 0;
 // printf("\nEnter an integer: ");
 // scanf("%d", &nn);

  nn = 5;
pp = nn;
 
  do {
    nn = nn -1;
    ++counter;
  } while (nn != 0);

  //printf("\nNumber of digits of integer %d is: %d\n", pp, counter);
}
