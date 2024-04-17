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
Including only final result  (synth -top wrapper)
```
```
3.25. Printing statistics.

=== ALU ===

   Number of wires:               2182
   Number of wire bits:           2880
   Number of public wires:          39
   Number of public wire bits:     737
   Number of ports:                 18
   Number of port bits:            192
   Number of memories:               0
   Number of memory bits:            0
   Number of processes:              0
   Number of cells:               2180
     $_ANDNOT_                     378
     $_AND_                         62
     $_MUX_                       1035
     $_NAND_                        64
     $_NOR_                        128
     $_NOT_                        100
     $_ORNOT_                       85
     $_OR_                         164
     $_XNOR_                        68
     $_XOR_                         96

=== ID ===

   Number of wires:                562
   Number of wire bits:            955
   Number of public wires:          37
   Number of public wire bits:     430
   Number of ports:                 16
   Number of port bits:            262
   Number of memories:               0
   Number of memory bits:            0
   Number of processes:              0
   Number of cells:                635
     $_ANDNOT_                     117
     $_AND_                          3
     $_MUX_                        421
     $_NAND_                         9
     $_NOR_                         17
     $_NOT_                         11
     $_ORNOT_                        9
     $_OR_                          48

=== IF_ID_pipeline ===

   Number of wires:                391
   Number of wire bits:            515
   Number of public wires:          37
   Number of public wire bits:     161
   Number of ports:                  7
   Number of port bits:             69
   Number of memories:               0
   Number of memory bits:            0
   Number of processes:              0
   Number of cells:                459
     $_ANDNOT_                      32
     $_MUX_                        160
     $_NAND_                        32
     $_NOT_                         34
     $_OR_                         128
     $_SDFF_PP0_                    73

=== M1_M2_pipeline ===

   Number of wires:                 17
   Number of wire bits:            103
   Number of public wires:          17
   Number of public wire bits:     103
   Number of ports:                 14
   Number of port bits:             38
   Number of memories:               0
   Number of memory bits:            0
   Number of processes:              0
   Number of cells:                 18
     $_SDFF_PP0_                    18

=== M2_WB_pipeline ===

   Number of wires:                 15
   Number of wire bits:             93
   Number of public wires:          15
   Number of public wire bits:      93
   Number of ports:                 14
   Number of port bits:             92
   Number of memories:               0
   Number of memory bits:            0
   Number of processes:              0
   Number of cells:                 40
     $_SDFF_PP0_                    40

=== forwarding_alu ===

   Number of wires:                108
   Number of wire bits:            275
   Number of public wires:          13
   Number of public wire bits:     180
   Number of ports:                 10
   Number of port bits:            177
   Number of memories:               0
   Number of memory bits:            0
   Number of processes:              0
   Number of cells:                159
     $_ANDNOT_                       1
     $_MUX_                        128
     $_NOR_                          1
     $_NOT_                          1
     $_OR_                          18
     $_XOR_                         10

=== id_mux ===

   Number of wires:                 40
   Number of wire bits:            346
   Number of public wires:          40
   Number of public wire bits:     346
   Number of ports:                 26
   Number of port bits:            332
   Number of memories:               0
   Number of memory bits:            0
   Number of processes:              0
   Number of cells:                165
     $_ANDNOT_                     165

=== pc_controller ===

   Number of wires:                147
   Number of wire bits:            420
   Number of public wires:          23
   Number of public wire bits:     289
   Number of ports:                 10
   Number of port bits:             86
   Number of memories:               0
   Number of memory bits:            0
   Number of processes:              0
   Number of cells:                139
     $_ANDNOT_                      23
     $_AND_                          5
     $_MUX_                         24
     $_NAND_                         9
     $_NOR_                         14
     $_NOT_                          1
     $_ORNOT_                        3
     $_OR_                           9
     $_SDFF_PP0_                     8
     $_XNOR_                        18
     $_XOR_                         25

=== reg_file ===

   Number of wires:               9454
   Number of wire bits:          11616
   Number of public wires:          55
   Number of public wire bits:    1225
   Number of ports:                 18
   Number of port bits:            227
   Number of memories:               0
   Number of memory bits:            0
   Number of processes:              0
   Number of cells:              11480
     $_ANDNOT_                    2149
     $_AND_                          2
     $_MUX_                       5958
     $_NAND_                        60
     $_NOR_                          1
     $_NOT_                          7
     $_ORNOT_                       85
     $_OR_                        2193
     $_SDFF_PP0_                  1025

=== stall_unit ===

   Number of wires:                 37
   Number of wire bits:             49
   Number of public wires:           8
   Number of public wire bits:      20
   Number of ports:                  6
   Number of port bits:             18
   Number of memories:               0
   Number of memory bits:            0
   Number of processes:              0
   Number of cells:                 30
     $_ANDNOT_                       7
     $_MUX_                          1
     $_NOR_                          2
     $_OR_                          10
     $_XNOR_                         1
     $_XOR_                          9

=== top ===

   Number of wires:                184
   Number of wire bits:           1749
   Number of public wires:         149
   Number of public wire bits:    1714
   Number of ports:                 17
   Number of port bits:            220
   Number of memories:               0
   Number of memory bits:            0
   Number of processes:              0
   Number of cells:                762
     $_ANDNOT_                      15
     $_AND_                        714
     $_MUX_                          5
     $_NAND_                         5
     $_NOR_                          2
     $_ORNOT_                        1
     $_OR_                          10
     ALU                             1
     ID                              1
     IF_ID_pipeline                  1
     M1_M2_pipeline                  1
     M2_WB_pipeline                  1
     forwarding_alu                  1
     id_mux                          1
     pc_controller                   1
     reg_file                        1
     stall_unit                      1

=== uart_rx ===

   Number of wires:                118
   Number of wire bits:            183
   Number of public wires:          14
   Number of public wire bits:      47
   Number of ports:                  7
   Number of port bits:             14
   Number of memories:               0
   Number of memory bits:            0
   Number of processes:              0
   Number of cells:                161
     $_ANDNOT_                      27
     $_AND_                          9
     $_DFF_P_                        4
     $_NAND_                         7
     $_NOR_                          3
     $_NOT_                          3
     $_ORNOT_                       14
     $_OR_                          41
     $_SDFFE_PN0N_                   1
     $_SDFFE_PN0P_                   8
     $_SDFFE_PN1P_                   2
     $_SDFFE_PP0P_                  26
     $_XOR_                         16

=== wrapper ===

   Number of wires:                 97
   Number of wire bits:            392
   Number of public wires:          32
   Number of public wire bits:     319
   Number of ports:                 11
   Number of port bits:             26
   Number of memories:               0
   Number of memory bits:            0
   Number of processes:              0
   Number of cells:                114
     $_ANDNOT_                      12
     $_AND_                          1
     $_DFF_P_                       12
     $_MUX_                          4
     $_NAND_                        19
     $_NOR_                          1
     $_NOT_                          5
     $_ORNOT_                        2
     $_OR_                          23
     $_SDFFE_PN0N_                   2
     $_SDFFE_PN0P_                  27
     $_SDFF_PP1_                     1
     $_XOR_                          3
     top                             1
     uart_rx                         1

=== design hierarchy ===

   wrapper                           1
     top                             1
       ALU                           1
       ID                            1
       IF_ID_pipeline                1
       M1_M2_pipeline                1
       M2_WB_pipeline                1
       forwarding_alu                1
       id_mux                        1
       pc_controller                 1
       reg_file                      1
       stall_unit                    1
     uart_rx                         1

   Number of wires:              13352
   Number of wire bits:          19576
   Number of public wires:         479
   Number of public wire bits:    5664
   Number of ports:                174
   Number of port bits:           1753
   Number of memories:               0
   Number of memory bits:            0
   Number of processes:              0
   Number of cells:              16330
     $_ANDNOT_                    2926
     $_AND_                        796
     $_DFF_P_                       16
     $_MUX_                       7736
     $_NAND_                       205
     $_NOR_                        169
     $_NOT_                        162
     $_ORNOT_                      199
     $_OR_                        2644
     $_SDFFE_PN0N_                   3
     $_SDFFE_PN0P_                  35
     $_SDFFE_PN1P_                   2
     $_SDFFE_PP0P_                  26
     $_SDFF_PP0_                  1164
     $_SDFF_PP1_                     1
     $_XNOR_                        87
     $_XOR_                        159

3.26. Executing CHECK pass (checking for obvious problems).
Checking module ALU...
Checking module ID...
Checking module IF_ID_pipeline...
Checking module M1_M2_pipeline...
Checking module M2_WB_pipeline...
Checking module forwarding_alu...
Checking module id_mux...
Checking module pc_controller...
Checking module reg_file...
Checking module stall_unit...
Checking module top...
Checking module uart_rx...
Checking module wrapper...
Found and reported 0 problems.
```
```
Including only final result  (synth -top wrapper  abc -liberty sky130_fd_sc_hd__tt_025C_1v80_256.lib)
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

show wrapper

![image](https://github.com/joses-bot/vsdiat_workshop/assets/83429049/86996d27-4bf6-4742-af63-0bc6e2409127)



