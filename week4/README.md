### C Code removing - system calls & system libraries (include/printf/scanf, etc)
Changing global variables into local ones

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
0000000000010184 <main>:
   10184:	ff010113          	addi	sp,sp,-16
   10188:	00113423          	sd	ra,8(sp)
   1018c:	00813023          	sd	s0,0(sp)
   10190:	01010413          	addi	s0,sp,16
   10194:	000217b7          	lui	a5,0x21
   10198:	57078513          	addi	a0,a5,1392 # 21570 <__clzdi2+0x44>
   1019c:	660000ef          	jal	ra,107fc <printf>
   101a0:	00000793          	li	a5,0
   101a4:	00078513          	mv	a0,a5
   101a8:	15c000ef          	jal	ra,10304 <setmosfet>
   101ac:	00000793          	li	a5,0
   101b0:	00078513          	mv	a0,a5
   101b4:	110000ef          	jal	ra,102c4 <convst_rd>
   101b8:	800007b7          	lui	a5,0x80000
   101bc:	00078513          	mv	a0,a5
   101c0:	0c4000ef          	jal	ra,10284 <setconvst>
   101c4:	000247b7          	lui	a5,0x24
   101c8:	6687a783          	lw	a5,1640(a5) # 24668 <moisture_level>
   101cc:	00078713          	mv	a4,a5
   101d0:	19000793          	li	a5,400
   101d4:	08e7cc63          	blt	a5,a4,1026c <main+0xe8>
   101d8:	000217b7          	lui	a5,0x21
   101dc:	5a878513          	addi	a0,a5,1448 # 215a8 <__clzdi2+0x7c>
   101e0:	61c000ef          	jal	ra,107fc <printf>
   101e4:	000247b7          	lui	a5,0x24
   101e8:	66c7a783          	lw	a5,1644(a5) # 2466c <water_level>
   101ec:	25800693          	li	a3,600
   101f0:	19000613          	li	a2,400
   101f4:	00078593          	mv	a1,a5
   101f8:	000217b7          	lui	a5,0x21
   101fc:	5c878513          	addi	a0,a5,1480 # 215c8 <__clzdi2+0x9c>
   10200:	5fc000ef          	jal	ra,107fc <printf>
   10204:	100007b7          	lui	a5,0x10000
   10208:	00078513          	mv	a0,a5
   1020c:	0f8000ef          	jal	ra,10304 <setmosfet>
   10210:	000217b7          	lui	a5,0x21
   10214:	60078513          	addi	a0,a5,1536 # 21600 <__clzdi2+0xd4>
   10218:	5e4000ef          	jal	ra,107fc <printf>
   1021c:	00200513          	li	a0,2
   10220:	1c0000ef          	jal	ra,103e0 <delay_val>
   10224:	000217b7          	lui	a5,0x21
   10228:	64078513          	addi	a0,a5,1600 # 21640 <__clzdi2+0x114>
   1022c:	5d0000ef          	jal	ra,107fc <printf>
   10230:	00000793          	li	a5,0
   10234:	00078513          	mv	a0,a5
   10238:	0cc000ef          	jal	ra,10304 <setmosfet>
   1023c:	218000ef          	jal	ra,10454 <full_adc_conversion>
   10240:	000247b7          	lui	a5,0x24
   10244:	66c7a783          	lw	a5,1644(a5) # 2466c <water_level>
   10248:	00078713          	mv	a4,a5
   1024c:	18f00793          	li	a5,399
   10250:	f8e7dae3          	bge	a5,a4,101e4 <main+0x60>
   10254:	000247b7          	lui	a5,0x24
   10258:	66c7a783          	lw	a5,1644(a5) # 2466c <water_level>
   1025c:	00078713          	mv	a4,a5
   10260:	25800793          	li	a5,600
   10264:	f8e7c0e3          	blt	a5,a4,101e4 <main+0x60>
   10268:	f5dff06f          	j	101c4 <main+0x40>
   1026c:	000217b7          	lui	a5,0x21
   10270:	65878513          	addi	a0,a5,1624 # 21658 <__clzdi2+0x12c>
   10274:	588000ef          	jal	ra,107fc <printf>
   10278:	00300513          	li	a0,3
   1027c:	164000ef          	jal	ra,103e0 <delay_val>
   10280:	f45ff06f          	j	101c4 <main+0x40>

0000000000010284 <setconvst>:
   10284:	fd010113          	addi	sp,sp,-48
   10288:	02813423          	sd	s0,40(sp)
   1028c:	03010413          	addi	s0,sp,48
   10290:	00050793          	mv	a5,a0
   10294:	fcf42e23          	sw	a5,-36(s0)
   10298:	800007b7          	lui	a5,0x80000
   1029c:	fff7c793          	not	a5,a5
   102a0:	fef42623          	sw	a5,-20(s0)
   102a4:	fdc42783          	lw	a5,-36(s0)
   102a8:	fec42703          	lw	a4,-20(s0)
   102ac:	00ef7f33          	and	t5,t5,a4
   102b0:	00ff6f33          	or	t5,t5,a5
   102b4:	00000013          	nop
   102b8:	02813403          	ld	s0,40(sp)
   102bc:	03010113          	addi	sp,sp,48
   102c0:	00008067          	ret

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
