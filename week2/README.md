## Assignment

+ Verify all the c code (counter, matrix multiplication, ALU code using RISC-V compiler and spike output.
+ Measure CPU performance of all the programs mentioned above using either godbolt or RISC-V disassembler.
+ Verify all the c code (counter, matrix multiplication, ALU code using RISC-V compiler and spike output.

## Commands to compile code using riscv compiler

riscv64-unknown-elf-gcc -march=rv64i -mabi=lp64 -ffreestanding  -o output file.c

## Code for Counter.C (count number of digits of number)

  ```
  riscv64-unknown-elf-gcc -march=rv64i -mabi=lp64 -ffreestanding -o ./counter counter.c
  spike pk counter
  
  ```
## Code for Counter.C
```
#include <stdio.h>
int main() {
  int nn, pp;
  int counter = 0;
  printf("\nEnter an integer: ");
  scanf("%d", &nn);

  nn = 5;
pp = nn;
 
  do {
    nn = nn -1;
    ++counter;
  } while (nn != 0);

  printf("\nNumber of digits of integer %d is: %d\n", pp, counter);
}

```
![image](https://github.com/joses-bot/jose_vdiasat_workshop/assets/83429049/ba70d501-3f00-4a15-9910-bc5cbc6c4f0e)

## Code for Matrix Multiplication.C
```
#include <stdio.h>

int main() {
    int array1[4][4]  = {{1, 2, 3, 4}, {5, 6, 7, 8}, {9, 10, 11, 12}, {13, 14, 15, 16}};
    int array2[4][4]  = {{1, 0, 0, 0}, {0, 1, 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}};
    int mresult[4][4] = {{0, 0, 0, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}};
    int ii,jj,kk;

    for (ii = 0; ii < 4; ii++) {
        for (jj = 0; jj < 4; jj++) {
            for (kk = 0; kk < 4; kk++) {
                mresult[ii][jj] = mresult[ii][jj] + array1[ii][kk] * array2[kk][jj];
            }
        }
    }

    printf("Matrix Array1:\n");
    for (ii = 0; ii < 4; ii++) {
        for (jj = 0; jj < 4; jj++) {
            printf("%d ", array1[ii][jj]);
        }
        printf("\n");
    }
    printf("Matrix Array2:\n");
    for (ii = 0; ii < 4; ii++) {
        for (jj = 0; jj < 4; jj++) {
            printf("%d ", array2[ii][jj]);
        }
        printf("\n");
    }

    printf("Matrix Mult Result:\n");
    for (ii = 0; ii < 4; ii++) {
        for (jj = 0; jj < 4; jj++) {
            printf("%d ", mresult[ii][jj]);
        }
        printf("\n");
    }

    return 0;
}


```
### Spike Simulation
![image](https://github.com/joses-bot/jose_vdiasat_workshop/assets/83429049/926c2582-c434-4438-a610-349528681977)

## Code for ALU.C                        
```
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

```
### Spike Simulation

![image](https://github.com/joses-bot/jose_vdiasat_workshop/assets/83429049/85bdd81b-e62c-4169-bd0b-0f959ff549c6)


## Assignment 2
+ Measure CPU performance of all the programs mentioned above using either godbolt or RISC-V disassembler.

  ### Command
  ```
  riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -ffreestanding -o  output file.c
  riscv64-unknown-elf-objdump -d -r output > file_assembly.txt
  ```

Let us assume the number of clock cycles for the RISC-V instructions.

Instructions with add                                             : 2 cycles.

Instructions with  mul, div, load, store, and move : 3 cycles.

Instructions with jump, and branch                       : 4 cycles.

All other Instructions                                             : 2 cycles.

**# Counter**

**CPU performance - Portion of code**
```
counter.o:     file format elf32-littleriscv


Disassembly of section .text:

00010054 <main>:
   10054:	fe010113          	addi	sp,sp,-32  -> 2
   10058:	00812e23          	sw	s0,28(sp)          -> 3
   1005c:	02010413          	addi	s0,sp,32   -> 2
   10060:	fe042423          	sw	zero,-24(s0)     -> 3
   10064:	00500793          	li	a5,5                 -> 3
   10068:	fef42623          	sw	a5,-20(s0)        -> 3
   1006c:	fec42783          	lw	a5,-20(s0)        -> 3
   10070:	fef42223          	sw	a5,-28(s0)        -> 3
   10074:	fec42783          	lw	a5,-20(s0)        -> 3
   10078:	fff78793          	addi	a5,a5,-1   -> 2
   1007c:	fef42623          	sw	a5,-20(s0)        -> 3
   10080:	fe842783          	lw	a5,-24(s0)        -> 3
   10084:	00178793          	addi	a5,a5,1    -> 2
   
```
Clock cycle per instruction (CPI) = Total number of clock cycles / Number of instructions

So, CPI will be 35/ 13 = 2.69.

Now,  CPU time = CPI x Number of instructions for a program x Clock cycle time (T)

Let's assume, T = 80ps.

So, CPU time = 2.69 x 13 x 80ps = 2798ps ~ 2.8ns.

**# Matrix Multiplication - Portion of code**

**CPU performance**
```
maatrix_mul.o:     file format elf32-littleriscv


Disassembly of section .text:

00010054 <main>:
   10054:	f2010113          	addi	sp,sp,-224     -> 2
   10058:	0c112e23          	sw	ra,220(sp)             -> 3
   1005c:	0c812c23          	sw	s0,216(sp)             -> 3
   10060:	0e010413          	addi	s0,sp,224      -> 2
   10064:	000107b7          	lui	a5,0x10                 -> 2
   10068:	34878713          	addi	a4,a5,840      -> 2
   1006c:	fa440793          	addi	a5,s0,-92       -> 2
   10070:	00070693          	mv	a3,a4                    -> 3
   10074:	04000713          	li	a4,64                    -> 2
   10078:	00070613          	mv	a2,a4                    -> 3
   1007c:	00068593          	mv	a1,a3                    -> 3
   10080:	00078513          	mv	a0,a5                   -> 3
   10084:	1a8000ef          	jal	ra,1022c <memcpy>  -> 4
   10088:	000107b7          	lui	a5,0x10                      -> 2
```
Clock cycle per instruction (CPI) = Total number of clock cycles / Number of instructions

So, CPI will be 36/ 14 = 2.571.

Now,  CPU time = CPI x Number of instructions for a program x Clock cycle time (T)

Let's assume, T = 80ps.

So, CPU time = 2.571 x 14 x 80ps = 2880ps ~ 2.880ns.

**# ALU - Portion of code**

**CPU performance**
```
basic_alu.o:     file format elf32-littleriscv

Disassembly of section .text:

00010054 <main>:
   10054:	fe010113          	addi	sp,sp,-32   -> 2
   10058:	00112e23          	sw	ra,28(sp)            -> 3
   1005c:	00812c23          	sw	s0,24(sp)           -> 3
   10060:	02010413          	addi	s0,sp,32    -> 2
   10064:	00a00793          	li	a5,10                -> 2
   10068:	fef42623          	sw	a5,-20(s0)        -> 3
   1006c:	0ac0006f          	j	10118 <main+0xc4> ->4
   10070:	00a00793          	li	a5,10                -> 2
   10074:	fef42423          	sw	a5,-24(s0)        -> 3
   10078:	0880006f          	j	10100 <main+0xac>  -> 4
   1007c:	00000613          	li	a2,0                 -> 2
   10080:	fe842583          	lw	a1,-24(s0)       -> 2
   10084:	fec42503          	lw	a0,-20(s0)      -> 2
   10088:	0b4000ef          	jal	ra,1013c <alu> -> 4
   1008c:	fea42223          	sw	a0,-28(s0)         -> 3
   10090:	00100613          	li	a2,1                  -> 2
   10094:	fe842583          	lw	a1,-24(s0)         -> 2
   10098:	fec42503          	lw	a0,-20(s0)         -> 2
   1009c:	0a0000ef          	jal	ra,1013c <alu> -> 4

```
Clock cycle per instruction (CPI) = Total number of clock cycles / Number of instructions

So, CPI will be 51/ 19 = 2.684.

Now,  CPU time = CPI x Number of instructions for a program x Clock cycle time (T)

Let's assume, T = 80ps.

So, CPU time = 2.684x 19 x 80ps = 4080ps ~ 4.080ns.

