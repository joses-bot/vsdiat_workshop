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




