//Basic Combinatorial ALU

module basic_alu(
input [2:0]opcode,
input [7:0]OperandA,OperandB,
output reg [7:0]rest
    );
    
always @(*)begin
case(instruction)
3'b000:
    rest = OperandA + B;
3'b001:
    rest = OperandA - B;
3'b010:
    rest = OperandA / B;
3'b011:
    rest = OperandA * B;  
3'b100:
    rest = OperandA & B; 
3'b101:
    rest = OperandA | B;
3'b110:
    rest = ~OperandA;
3'b111:
    rest = OperandA ^ OperandA;
default:
    rest = 0;
    endcase
end

endmodule