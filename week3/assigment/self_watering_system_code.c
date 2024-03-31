#include<stdio.h> 
#include<stdlib.h>

/* Define how long the pump will run (2 seconds) */
#define PUMP_TIME 2

/* Define Level of Water required */
#define LVL_HIGH 600  
#define LVL_LOW  400 

/* Define Level of moisture level required */
#define MOISTURE_LOW  400  

#define ADC_CHANNELS 8

/* GPIO bits */
const int ON   1;   
const int OFF  0;   

/* Define idle time for next check (3 seconds) */
#define IDLE_TIME 3

void setconvst(int convst);
void convst_rd(int convstrd);
void setmosfet(int mosfet_val);
int read_busy();
int read_adc_val();
void delay_val(int seconds);
void full_adc_conversion();

/* Global variables */
int moisture_level;
int water_level;

int main() {

int busy;

  /* Initially keep motor OFF - ADC Converter RD signal to 0 */
  setmosfet(OFF);
  convst_rd(OFF);
  setconvst(ON);

  while(1){


  /* If the soil moisture is HIGH, report everything as perfect! */
  if (moisture_level <= MOISTURE_LOW) {
     printf("\n"Low moisture! Time to water! \n");
   
     do {
        setmosfet(ON);
        delay_val(PUMP_TIME);  /*Keep the pump active for some short time */
        setmosfet(OFF);
        full_adc_conversion(); /* Get new values */
     }
     while( !((water_level >= LVL_LOW) && (water_level <= LVL_HIGH)));  /* Wait until water level is in range */
     }
  }
  else {
       printf("\nEverything OK, The water pump is on standby \n");
       delay_val(IDLE_TIME);
       }

 }
    return 0;  /* Not used */
}

void setconvst(int convst){
int mask = 0x7FFFFFFF;  /* Bit 31 */

    asm volatile(
        "and x30, x30, %1\n\t"
        "or x30, x30, %0\n\t"
        :
        : "r"(convst), "r"(mask1)
        : "x30"
    );

}

void convst_rd(int convstrd){
int mask = 0xBFFFFFFF;  /* Bit 30 */

    asm volatile(
        "and x30, x30, %1\n\t"
        "or x30, x30, %0\n\t"
        :
        : "r"(convst), "r"(mask1)
        : "x30"
    );

}

void setmosfet(int mosfet_val){
int mask = 0xEFFFFFFF;  /* Bit 28 */

    asm volatile(
        "and x30, x30, %1\n\t"
        "or x30, x30,  %1\n\t"
        :
        : "r"(mosfet_val), "r"(mask1)
        : "x30"
    );

}

int read_busy(){
int busy_val; 

    asm volatile(
        "srli x10, x30, 29\n\t"  /* Bit 29 */
        "andi %0, x10, 1\n\t"
        : "=r"(busy_val)
        :
        : "x30"
    );
    return busy_val;
}

int read_adc_val(){
int adc_conv; 

    asm volatile(
        "srli x10, x30, 15\n\t"  /* Bits 15-0 */
        "andi %0, x10, 31\n\t"
        : "=r"(adc_conv)
        :
        : "x30"
    );
    return adc_conv;
}

void delay_val(int seconds){
int i;

for (i = 0; i < seconds * 1000000 ; i++){
asm ("nop");
}
}

void full_adc_conversion(){
  int jj;

  setconvst(ON);
  setconvst(OFF);  /* Transition to low starts conversion */
  setconvst(ON);

  do {
    asm ("nop");
  }
  while (read_busy() == ON);  /* Wait until conversion ends */

  for (jj = 0; jj < ADC_CHANNELS ; jj ++){
    if(jj == 0){
       convst_rd(ON);
       moisture_level = read_adc_val();  /* Read soil moisture level (global variable) */ 
       convst_rd(OFF);
    }
    else if(jj == 1){
       convst_rd(ON);
       water_level = read_adc_val();  /* Read water level  (global variable) */
       convst_rd(OFF);
    }      
    else  {
       convst_rd(ON);    /* Dummhy reads */
       convst_rd(OFF);
   }    
   }
}
