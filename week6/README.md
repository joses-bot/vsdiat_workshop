### UART Bypass

In Testbench file comment out all the occurrences of:
@(posedge slow_clk);write_instruction(32'h00000000). 

As instructions are already written in the memory when variable ASIC  is "false" in .json file. 

In rocessor.v file under wrapper module verify - writing_inst_done=1;

### Regenerate again iverilog Simulation

iverilog -o self_watering_system_code_v testbench1.v processor1.v

vvp self_watering_system_code_v -fst

![image](https://github.com/joses-bot/vsdiat_workshop/assets/83429049/d36ca831-63a9-49ed-83de-3c09631418a0)


### Showing waveforms with GTKwave

![image](https://github.com/joses-bot/vsdiat_workshop/assets/83429049/437dd3a5-f4ff-4722-970c-c389007d19b4)

### GATE-LEVEL SYNTHESIS

Synthesis transforms the simple RTL design into a gate-level netlist with all the constraints as specified by the designer. In simple language, Synthesis is a process that converts the abstract form of design to a properly implemented chip in terms of logic gates.

Synthesis takes place by performing the RTL convertion into simple logic gates then mapping the resultant gates into technology dependant gates available inthe technology used


### YOSYS Installation

Installing Yosys: https://github.com/YosysHQ/yosys on the vsdworkshop VM.

git clone https://github.com/YosysHQ/yosys yosys --depth 1

sudo apt install build-essential clang bison flex libreadline-dev \
    gawk tcl-dev libffi-dev git graphviz \
    xdot pkg-config python python3 libftdi-dev \
    qt5-default python3-dev libboost-all-dev cmake libeigen3-dev

cd yosys
git fetch --unshallow

make -j$(nproc)
sudo make install

Reading design

![image](https://github.com/joses-bot/vsdiat_workshop/assets/83429049/4c61bf7e-2743-45a0-a70b-e072d469e1fa)

Analyzing herarchie:

![image](https://github.com/joses-bot/vsdiat_workshop/assets/83429049/98328a5b-3d10-455a-a85a-28567b78d637)

### Gate Level Simulation :

GLS is generating the simulation output by running test bench with netlist file generated from synthesis as design under test. Netlist is logically same as RTL code, therefore, same test bench can be used for it.We perform this to verify logical correctness of the design after synthesizing it. Also ensuring the timing of the design is met. Folllowing are the commands to we need to convert Rtl code to netlist in yosys for that commands are :

```
read_liberty -lib sky130_fd_sc_hd__tt_025C_1v80_256.lib 
read_verilog processor.v 
synth -top wrapper
dfflibmap -liberty sky130_fd_sc_hd__tt_025C_1v80_256.lib 
abc -liberty sky130_fd_sc_hd__tt_025C_1v80_256.lib
write_verilog synth_processor_test.v
```

```
vsduser@vsduser-VirtualBox:~/yosys$ yosys

 /----------------------------------------------------------------------------\
 |  yosys -- Yosys Open SYnthesis Suite                                       |
 |  Copyright (C) 2012 - 2024  Claire Xenia Wolf <claire@yosyshq.com>         |
 |  Distributed under an ISC-like license, type "license" to see terms        |
 \----------------------------------------------------------------------------/
 Yosys 0.40+7 (git sha1 b827b9862, g++ 7.5.0-3ubuntu1~18.04 -fPIC -Os)

yosys> 

yosys> 

yosys> 

yosys> read_liberty -lib sky130_fd_sc_hd__tt_025C_1v80_256.lib 

1. Executing Liberty frontend: sky130_fd_sc_hd__tt_025C_1v80_256.lib
Imported 429 cell types from liberty file.

yosys> read_verilog processor.v

2. Executing Verilog-2005 frontend: processor.v
Parsing Verilog input from `processor.v' to AST representation.
Generating RTLIL representation for module `\ALU'.
Generating RTLIL representation for module `\ID'.
Generating RTLIL representation for module `\IF_ID_pipeline'.
Generating RTLIL representation for module `\M1_M2_pipeline'.
Generating RTLIL representation for module `\M2_WB_pipeline'.
Generating RTLIL representation for module `\forwarding_alu'.
Generating RTLIL representation for module `\id_mux'.
Generating RTLIL representation for module `\pc_controller'.
Generating RTLIL representation for module `\reg_file'.
Generating RTLIL representation for module `\stall_unit'.
Generating RTLIL representation for module `\top'.
Generating RTLIL representation for module `\uart_rx'.
Generating RTLIL representation for module `\wrapper'.
Successfully finished Verilog frontend.

yosys> 
```
```
Including only final result
```
```
ABC RESULTS:   sky130_fd_sc_hd__nor3_1 cells:        2
ABC RESULTS:   sky130_fd_sc_hd__nor2_1 cells:       50
ABC RESULTS:   sky130_fd_sc_hd__nand4_1 cells:        8
ABC RESULTS:   sky130_fd_sc_hd__nor4_1 cells:        1
ABC RESULTS:   sky130_fd_sc_hd__a31o_1 cells:        1
ABC RESULTS:        internal signals:       99
ABC RESULTS:           input signals:       44
ABC RESULTS:          output signals:       32
Removing temp directory.

yosys> write_verilog synth_processor_test.v

6. Executing Verilog backend.

6.1. Executing BMUXMAP pass.

6.2. Executing DEMUXMAP pass.
Dumping module `\ALU'.
Dumping module `\ID'.
Dumping module `\IF_ID_pipeline'.
Dumping module `\M1_M2_pipeline'.
Dumping module `\M2_WB_pipeline'.
Dumping module `\forwarding_alu'.
Dumping module `\id_mux'.
Dumping module `\pc_controller'.
Dumping module `\reg_file'.
Dumping module `\stall_unit'.
Dumping module `\top'.
Dumping module `\uart_rx'.
Dumping module `\wrapper'.

yosys> 
```



### To run the GLS simulation:

est synth_processor_test.v testbench.v sky130_sram_1kbyte_1rw1r_32x256_8.v sky130_fd_sc_hd.v primitives.v




