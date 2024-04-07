### UPDATING THE JSON FILE AND GENERATING THE RTL FOR OUR SPECIFIC APP USING THE CHIPCRON TOOL

![image](https://github.com/joses-bot/jose_vdiasat_workshop/assets/83429049/5298ce34-1041-4631-83f2-2da43443d4bf)


### Files Generated:

```
processor.v
testbench.v

```

### Modifying GPIO's to match the ones used in the design

processor.v gpio input and output verilog changes for the x30 register.

```
    module wrapper(clk,resetn,uart_rxd,uart_rx_en,uart_rx_break,uart_rx_valid,uart_rx_data, output_gpio_pins, input_gpio_pins, write_done, instructions);
    input clk;
    output reg write_done ; 
    output reg [2:0] instructions ; 
    input wire [16:0] input_gpio_pins;
    output reg [2:0] output_gpio_pins;  
```

```
    always @(posedge clk) 
    begin
    output_pins = {12'b0, top_gpio_pins[19:17],  input_gpio_pins[16:0]} ; 
    output_gpio_pins = top_gpio_pins[19:17]; 
    write_done = writing_inst_done ; 
    instructions = write_inst_count[2:0]; 

    end 
```

### Functional Simulation using UART

Chipcron tool has been used to generate the RTL design for our specific application and the testbench 

To simulate the code for our specific app using the Iverilog simulator we use the following commands:

```
iverilog -o self_watering_system_code_v testbench.v processor.v
vvp self_watering_system_code_v

```
A file self_watering_system_code_v is generated (the full version is in the folder):

```
#! /usr/local/bin/vvp
:ivl_version "10.3 (stable)" "(v10_3-42-gb98854309-dirty)";
:ivl_delay_selection "TYPICAL";
:vpi_time_precision + 0;
:vpi_module "system";
:vpi_module "vhdl_sys";
:vpi_module "v2005_math";
:vpi_module "va_math";
S_0x55b6e90b3350 .scope module, "tb" "tb" 2 13;
 .timescale 0 0;
P_0x55b6e90eb9a0 .param/l "BIT_P" 1 2 36, +C4<00000000000000011001011011100110>;
P_0x55b6e90eb9e0 .param/l "BIT_RATE" 1 2 35, +C4<00000000000000000010010110000000>;
P_0x55b6e90eba20 .param/l "CLK_HZ" 1 2 40, +C4<00000010111110101111000010000000>;
P_0x55b6e90eba60 .param/l "CLK_P" 1 2 41, +C4<00000000000000000000000000010100>;
v0x55b6e914ac50_0 .var "clk", 0 0;
v0x55b6e914ad10_0 .var/i "fails", 31 0;
v0x55b6e914adf0_0 .var "input_wires", 16 0;
v0x55b6e914aef0_0 .var "neg_clk", 0 0;
v0x55b6e914af90_0 .var "neg_rst", 0 0;
v0x55b6e914b0a0_0 .net "output_wires", 2 0, v0x55b6e9149670_0;  1 drivers
v0x55b6e914b160_0 .var/i "passes", 31 0;
v0x55b6e914b220_0 .var "resetn", 0 0;
v0x55b6e914b310_0 .var "rst", 0 0;
v0x55b6e914b3d0_0 .var "rst_pin", 0 0;
v0x55b6e914b490_0 .var "slow_clk", 0 0;
v0x55b6e914b550_0 .net "uart_rx_break", 0 0, L_0x55b6e917c110;  1 drivers
v0x55b6e914b5f0_0 .net "uart_rx_data", 7 0, v0x55b6e9148160_0;  1 drivers
v0x55b6e914b700_0 .var "uart_rx_en", 0 0;
v0x55b6e914b7f0_0 .net "uart_rx_valid", 0 0, L_0x55b6e917c6b0;  1 drivers
v0x55b6e914b8e0_0 .var "uart_rxd", 0 0;
v0x55b6e914b9d0_0 .net "write_done", 0 0, v0x55b6e914a330_0;  1 drivers
E_0x55b6e89bfe30 .event posedge, v0x55b6e914b490_0;
S_0x55b6e8fda7f0 .scope task, "check_byte" "check_byte" 2 92, 2 92 0, S_0x55b6e90b3350;
 .timescale 0 0;
v0x55b6e9008050_0 .var "expected_value", 7 0;
TD_tb.check_byte ;
    %load/vec4 v0x55b6e914b5f0_0;
    %load/vec4 v0x55b6e9008050_0;
    %cmp/e;
    %jmp/0xz  T_0.0, 4;
    %load/vec4 v0x55b6e914b160_0;
    %addi 1, 0, 32;
    %store/vec4 v0x55b6e914b160_0, 0, 32;
    %load/vec4 v0x55b6e914b160_0;
    %load/vec4 v0x55b6e914ad10_0;
    %add;
	  %vpi_call 2 97 "$display", "%d/%d/%d [PASS] Expected %b and got %b", v0x55b6e914b160_0, v0x55b6e914ad10_0, S<0,vec4,s32>, v0x55b6e9008050_0, v0x55b6e914b5f0_0 {1 0 0};
    %jmp T_0.1;
T_0.0 ;
    %load/vec4 v0x55b6e914ad10_0;
    %addi 1, 0, 32;
    %store/vec4 v0x55b6e914ad10_0, 0, 32;
    %load/vec4 v0x55b6e914b160_0;
    %load/vec4 v0x55b6e914ad10_0;
    %add;

```

![Screenshot 2024-04-07 011014](https://github.com/joses-bot/vsdiat_workshop/assets/83429049/fbd82d28-5b39-4d2c-8a15-a14bc190ff64)



