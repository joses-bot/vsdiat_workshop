### C Code removing - system calls & system libraries (include/printf/scanf, etc)

```
/////#include<stdio.h> 
/////#include<stdlib.h>

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
void full_adc_conversion(int *moisture_level, int *water_level);

// Change global variables into local ones /* Global variables */
/////int moisture_level;
////int water_level;

/*Just for simulation*/
int write_busy(int busy_val);

int main() {

int busy;
int moisture_level=0;
int water_level=0;


  /* Initially keep motor OFF - ADC Converter RD signal to 0 */
  //////printf("\nSystem start - Water Pump motor off - ADC initialized\n");
  setmosfet(MOSFET_OFF);
  convst_rd(RD_OFF);
  setconvst(CONV_ON);

  while(1){


  /* If the soil moisture is HIGH, report everything as perfect! */
  if (moisture_level <= MOISTURE_LOW) {
     //////printf("\nLow moisture! Time to water! \n");
   
     do {
        /////printf("\nCheck water level = %d (Must be within %d and %d)\n", water_level, LVL_LOW, LVL_HIGH );
        setmosfet(MOSFET_ON);
        /////printf("\nWater level low - Water Pump swtich ON for a short time\n");
        delay_val(PUMP_TIME);  /*Keep the pump active for some short time */
        /////printf("\nWater Pump swtich OFF\n");
        setmosfet(MOSFET_OFF);
        /*Just for simulation*/
        ///write_busy(BUSY_ON);
        full_adc_conversion(&moisture_level, &water_level); /* Get new values */
     }
     while( !((water_level >= LVL_LOW) && (water_level <= LVL_HIGH)));  /* Wait until water level is in range */
     }
  else {
       /////printf("\nEverything OK, The water pump is on standby \n");
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

void full_adc_conversion(int *moisture_level, int *water_level){
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
       *moisture_level = read_adc_val();  /* Read soil moisture level (global variable) */ 
       convst_rd(RD_OFF);
       //////printf("\nRead soild moisture level = %d\n", *moisture_level);
    }
    else if(jj == 1){
       convst_rd(RD_ON);
       *water_level = read_adc_val();  /* Read water level  (global variable) */
       convst_rd(RD_OFF);
       //////printf("\nRead water level = %d\n", *water_level);
    }      
    else  {
       convst_rd(RD_ON);    /* Dummhy reads */
       convst_rd(RD_OFF);
   }    
   }
}

```

### Compilation section

### Compilation commands:

riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -o  self_watering_system_code..o self_watering_system_code..c

riscv64-unknown-elf-objdump -d -r self_watering_system_code..o > self_watering_system_code..txt

self_watering_system_code.o:     file format elf32-littleriscv

### Assembly code generated (Portion of it, see complete file in folder)

Disassembly of section .text:

```
00010054 <main>:
   10054:	ff010113          	addi	sp,sp,-16
   10058:	00112623          	sw	ra,12(sp)
   1005c:	00812423          	sw	s0,8(sp)
   10060:	01010413          	addi	s0,sp,16
   10064:	00000793          	li	a5,0
   10068:	00078513          	mv	a0,a5
   1006c:	0ec000ef          	jal	ra,10158 <setmosfet>
   10070:	00000793          	li	a5,0
   10074:	00078513          	mv	a0,a5
   10078:	0a4000ef          	jal	ra,1011c <convst_rd>
   1007c:	000807b7          	lui	a5,0x80
   10080:	00078513          	mv	a0,a5
   10084:	05c000ef          	jal	ra,100e0 <setconvst>
   10088:	8281a703          	lw	a4,-2008(gp) # 113bc <_edata>
   1008c:	19000793          	li	a5,400
   10090:	04e7c263          	blt	a5,a4,100d4 <main+0x80>
   10094:	000207b7          	lui	a5,0x20
   10098:	00078513          	mv	a0,a5
   1009c:	0bc000ef          	jal	ra,10158 <setmosfet>
   100a0:	00200513          	li	a0,2
   100a4:	188000ef          	jal	ra,1022c <delay_val>
   100a8:	00000793          	li	a5,0
   100ac:	00078513          	mv	a0,a5
   100b0:	0a8000ef          	jal	ra,10158 <setmosfet>
   100b4:	1e4000ef          	jal	ra,10298 <full_adc_conversion>
   100b8:	82c1a703          	lw	a4,-2004(gp) # 113c0 <water_level>
   100bc:	18f00793          	li	a5,399
   100c0:	fce7dae3          	bge	a5,a4,10094 <main+0x40>
   100c4:	82c1a703          	lw	a4,-2004(gp) # 113c0 <water_level>
   100c8:	25800793          	li	a5,600
   100cc:	fce7c4e3          	blt	a5,a4,10094 <main+0x40>
   100d0:	fb9ff06f          	j	10088 <main+0x34>
   100d4:	00300513          	li	a0,3
   100d8:	154000ef          	jal	ra,1022c <delay_val>
   100dc:	fadff06f          	j	10088 <main+0x34>

000100e0 <setconvst>:
   100e0:	fd010113          	addi	sp,sp,-48
   100e4:	02812623          	sw	s0,44(sp)
   100e8:	03010413          	addi	s0,sp,48
   100ec:	fca42e23          	sw	a0,-36(s0)
   100f0:	fff807b7          	lui	a5,0xfff80
   100f4:	fff78793          	addi	a5,a5,-1 # fff7ffff <__global_pointer$+0xfff6e46b>
   100f8:	fef42623          	sw	a5,-20(s0)
   100fc:	fdc42783          	lw	a5,-36(s0)
   10100:	fec42703          	lw	a4,-20(s0)
   10104:	00ef7f33          	and	t5,t5,a4
   10108:	00ff6f33          	or	t5,t5,a5
   1010c:	00000013          	nop
   10110:	02c12403          	lw	s0,44(sp)
   10114:	03010113          	addi	sp,sp,48
   10118:	00008067          	ret

```

###  Unique Instructions:

```
Number of different instructions: 22
List of unique instructions:
sub
li
lw
mv
andi
nop
or
srli
bge
slli
and
ret
beq
addi
sw
blt
bne
jal
j
lui
bnez
add

```
