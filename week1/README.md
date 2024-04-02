### C Code to Assembly Level  (code in c files)
## Hello vdiasat

josep@josep-VirtualBox:</Desktop$ gcc hello_vdiasat.c -o hello_vdiasat
josep@josep-VirtualBox/Desktop$ ./hello_vdiasat
Hello Vdiasat

![image](https://github.com/joses-bot/vsdiat_workshop/assets/83429049/b97008d9-acb9-4ed3-a379-c000bd57da3c)

It looks like x86 produces a more compact code.  Uses better push-pop instructions. RISC uses sp register for the same purpose. Move instructions on x86 seem to be also more powerful (addressing modes).

   ./bin/riscv64-unknown-elf-gcc hello_vdiasat.c -o hello_vdiasat 
   ./bin/riscv64-unknown-elf-objdump -d hello_vdiasat > elf_format_hello_vdiasat

![hello_vdiasat_elf](https://github.com/joses-bot/vsdiat_workshop/assets/83429049/96fe96d3-a176-454f-9eea-2dbd3905fe55)

## Counter Example

josep@josep-VirtualBox:</Desktop$ gcc counter.c -o counter

![image](https://github.com/joses-bot/vsdiat_workshop/assets/83429049/96769fed-ce53-4ea8-af8a-3e0000887683)

![image](https://github.com/joses-bot/vsdiat_workshop/assets/83429049/bbb2933f-845d-4da8-a798-ececa8727026)

./bin/riscv64-unknown-elf-gcc hello_counter.c -o counter 
./bin/riscv64-unknown-elf-objdump -d counter > elf_format_counter

![counter_elf](https://github.com/joses-bot/vsdiat_workshop/assets/83429049/e5a6aeb5-1b56-46c6-a7b2-572976f8e331)


## Sum of natural numbers:

josep@josep-VirtualBox:/Desktop$ gcc sum1_N.c -o sum1_N
josep@josep-VirtualBox:/Desktop$ ./sum1_N
Enter Max number sum series: 4
Sum of first 4 numbers               = 10 
Sum of first 4 numbers using formula = 10 

![image](https://github.com/joses-bot/vsdiat_workshop/assets/83429049/bea56c72-6b29-442f-b6cf-4c62ca8a11f3)

./bin/riscv64-unknown-elf-gcc sum1_N.c -o sum1_N
./bin/riscv64-unknown-elf-objdump -d sum1_N > elf_format_sum1_N

![image](https://github.com/joses-bot/vsdiat_workshop/assets/83429049/2b48a871-f031-40ea-9a6c-d8cc7855adb9)

## Matrix Multiplication:

josep@josep-VirtualBox:/Desktop$ gcc matrix_mul.c -o matrix_mul
josep@josep-VirtualBox:/Desktop$ ./matrix_mul
Matrix Mult Result:
1 2 3 4 
5 6 7 8 
9 10 11 12 
13 14 15 16 

![image](https://github.com/joses-bot/vsdiat_workshop/assets/83429049/4ce83b72-dd7b-486b-a1d9-eeb632e6d457)

./bin/riscv64-unknown-elf-gcc matrix_mul.c -o matrix_mul 
./bin/riscv64-unknown-elf-objdump -d matrix_mul > elf_format_matrix_mul

![image](https://github.com/joses-bot/vsdiat_workshop/assets/83429049/ea2700e6-7005-4496-9c41-f22f95162277)


