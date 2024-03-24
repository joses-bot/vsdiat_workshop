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

end

endmodule