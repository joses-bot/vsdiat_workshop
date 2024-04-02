#### SIMPLE ALU USING VERILOG

![compile_alu](https://github.com/joses-bot/jose_vdiasat_workshop/assets/83429049/f878ccd5-06c1-42c7-b81a-d32d1401595c)

#### TEST BENCH

module alu_testbench;

reg [2:0]inst;
reg [7:0]A,B;
wire [7:0]result;

alu_verilog dut(inst,A,B,result);

integer jj;

initial begin
#20

A = 20; B = 10; 
inst = 0;

for( jj = 1; jj < 8; jj = jj+ 1)begin
    #10
    inst = jj;
    A = A + 10;
    B = B +5;
end

#20
$finish();

#### WAVEFORM RESULTS

![waveform_alu jpg](https://github.com/joses-bot/jose_vdiasat_workshop/assets/83429049/c5d527e9-0efd-43b9-8c18-4173011a346a)
