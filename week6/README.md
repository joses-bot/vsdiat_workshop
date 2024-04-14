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


