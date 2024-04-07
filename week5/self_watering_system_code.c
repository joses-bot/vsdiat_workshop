///#include<stdio.h> 
///#include<stdlib.h>

/* Define how long the pump will run (2 seconds) */
#define PUMP_TIME 2

/* Define Level of Water required */
#define LVL_HIGH 600  
#define LVL_LOW  400 

/* Define Level of moisture level required */
#define MOISTURE_LOW  400  

#define ADC_CHANNELS 8

/* GPIO bits */
const int ON =  1;   
const int OFF = 0; 
const int MOSFET_ON  = 0x00020000;  
const int MOSFET_OFF = 0x00000000; 
const int BUSY_ON    = 0x00010000;  
const int BUSY_OFF   = 0x00000000; 
const int RD_ON      = 0x00040000;  
const int RD_OFF     = 0x00000000;  
const int CONV_ON    = 0x00080000;  
const int CONV_OFF   = 0x00000000;   

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

/*Just for simulation*/
int write_busy(int busy_val);
int initialize_x30();

int main() {

int busy;

  /* Initially keep motor OFF - ADC Converter RD signal to 0 */
  /////printf("\nSystem start - Water Pump motor off - ADC initialized\n");
  setmosfet(MOSFET_OFF);
  convst_rd(RD_OFF);
  setconvst(CONV_ON);

  while(1){


  /* If the soil moisture is HIGH, report everything as perfect! */
  if (moisture_level <= MOISTURE_LOW) {
     //////printf("\nLow moisture! Time to water! \n");
   
     do {
        ////printf("\nCheck water level = %d (Must be within %d and %d)\n", water_level, LVL_LOW, LVL_HIGH );
        setmosfet(MOSFET_ON);
        ////printf("\nWater level low - Water Pump swtich ON for a short time\n");
        delay_val(PUMP_TIME);  /*Keep the pump active for some short time */
        ///printf("\nWater Pump swtich OFF\n");
        setmosfet(MOSFET_OFF);
        /*Just for simulation*/
        ///write_busy(BUSY_ON);
        full_adc_conversion(); /* Get new values */
     }
     while( !((water_level >= LVL_LOW) && (water_level <= LVL_HIGH)));  /* Wait until water level is in range */
     }
  else {
       //////printf("\nEverything OK, The water pump is on standby \n");
       delay_val(IDLE_TIME);
       }

 }
    return 0;  /* Not used */
}

void setconvst(int convst){
int mask = 0xFFF7FFFF;  /* Bit 19 */

    asm volatile(
        "and x30, x30, %1\n\t"
        "or x30, x30, %0\n\t"
        :
        : "r"(convst), "r"(mask)
        : "x30"
    );

}

void convst_rd(int convstrd){
int mask = 0xFFFBFFFF;  /* Bit 18 */

    asm volatile(
        "and x30, x30, %1\n\t"
        "or x30, x30, %0\n\t"
        :
        : "r"(convstrd), "r"(mask)
        : "x30"
    );

}

void setmosfet(int mosfet_val){
int mask = 0xFFFDFFFF;  /* Bit 17 */

    asm volatile(
        "and x30, x30, %1\n\t"
        "or x30, x30,  %0\n\t"
        :
        : "r"(mosfet_val), "r"(mask)
        : "x30"
    );

}


int write_busy(int busy_val){
int mask = 0xEFFEFFFF;  /* Bit 16 */

    asm volatile(
        "and x30, x30, %1\n\t"
        "or x30, x30,  %0\n\t"
        :
        : "r"(busy_val), "r"(mask)
        : "x30"
    );
}

int read_busy(){
int busy_val; 

    asm volatile(
        "srli x10, x30, 16\n\t"  /* Bit 16 */
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
  int conv_done;

  setconvst(CONV_ON);
  setconvst(CONV_OFF);  /* Transition to low starts conversion */
  setconvst(CONV_ON);

  do {
    asm ("nop");
  }  while ((conv_done = read_busy()) == ON);  /* Wait until conversion ends */

  for (jj = 0; jj < ADC_CHANNELS ; jj ++){
    if(jj == 0){
       convst_rd(RD_ON);
       moisture_level = read_adc_val();  /* Read soil moisture level (global variable) */ 
       convst_rd(RD_OFF);
       //////printf("\nRead soild moisture level = %d\n", moisture_level);
    }
    else if(jj == 1){
       convst_rd(RD_ON);
       water_level = read_adc_val();  /* Read water level  (global variable) */
       convst_rd(RD_OFF);
       //////printf("\nRead water level = %d\n", water_level);
    }      
    else  {
       convst_rd(RD_ON);    /* Dummhy reads */
       convst_rd(RD_OFF);
   }    
   }
}
