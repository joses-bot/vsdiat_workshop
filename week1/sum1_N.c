#include <stdio.h>

int main()
{
    int j, nn, tot_sum=0, sum=0;

    printf("Enter Max number sum series: ");
    scanf("%d", &nn);

    /* Find sum of all numbers */
    tot_sum = (nn * (nn +1))/2

    for(j=1; j<=nn; j++)
    {
        sum = sum +j ;
    }

    printf("Sum of first %d numbers               = %d \n ", nn, sum);
    printf("Sum of first %d numbers using formula = %d \n ", nn, tot_sum);


    return 0;
}