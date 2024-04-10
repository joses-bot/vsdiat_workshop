### UART Bypass

In Testbench file comment out all the occurrences of:
@(posedge slow_clk);write_instruction(32'h00000000). 

As instructions are already written in the memory when variable ASIC  is "false" in .json file. 

In rocessor.v file under wrapper module verify - writing_inst_done=1;

### Regenerate again iverilog Simulation

iverilog -o self_watering_system_code_v testbench1.v processor1.v

vvp self_watering_system_code_v -fst

![image](https://github.com/joses-bot/vsdiat_workshop/assets/83429049/1b046b0c-8d68-42ec-8831-b66bbf9f5ea3)

### Showing waveforms with GTKwave




