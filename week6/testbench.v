

// 
// Module: tb
// 
// Notes:
// - Top level simulation testbench.
//

//`timescale 1ns/1ns
//`define WAVES_FILE "./work/waves-rx.vcd"

module tb();
    
reg        clk          ; // Top level system clock input.
reg rst;
reg neg_clk; 
reg neg_rst ; 
reg        resetn       ;
reg        uart_rxd     ; // UART Recieve pin.

reg        uart_rx_en   ; // Recieve enable
//wire [8:0] res;
wire       uart_rx_break; // Did we get a BREAK message?
wire       uart_rx_valid; // Valid data recieved and available.
wire [7:0] uart_rx_data ; // The recieved data.
wire [31:0] inst ; 
wire [31:0] inst_mem ; 

reg rst_pin ; 
wire write_done ; 


// Bit rate of the UART line we are testing.
localparam BIT_RATE = 9600;
localparam BIT_P    = (1000000000/BIT_RATE);


// Period and frequency of the system clock.
localparam CLK_HZ   = 50000000;
localparam CLK_P    = 1000000000/ CLK_HZ;

reg slow_clk = 0;


// Make the clock tick.
always begin #(CLK_P/2) clk  = ~clk; end   
always begin #(CLK_P/2) neg_clk  = ~neg_clk; end     
always begin #(CLK_P*2) slow_clk <= !slow_clk;end



task write_instruction;
    input [31:0] instruction;
    begin
            @(posedge clk);
            send_byte(instruction[7:0]);
            check_byte(instruction[7:0]);
            @(posedge clk);
            send_byte(instruction[15:8]);
            check_byte(instruction[15:8]);
            
            @(posedge clk);
            send_byte(instruction[23:16]);
            check_byte(instruction[23:16]);
            
            @(posedge clk);
            send_byte(instruction[31:24]);
            check_byte(instruction[31:24]);
    end
    endtask

task send_byte;
    input [7:0] to_send;
    integer i;
    begin


        #BIT_P;  uart_rxd = 1'b0;
        for(i=0; i < 8; i = i+1) begin
            #BIT_P;  uart_rxd = to_send[i];
        end
        #BIT_P;  uart_rxd = 1'b1;
        #1000;
    end
endtask


// Checks that the output of the UART is the value we expect.
integer passes = 0;
integer fails  = 0;
task check_byte;
    input [7:0] expected_value;
    begin
        if(uart_rx_data == expected_value) begin
            passes = passes + 1;
            $display("%d/%d/%d [PASS] Expected %b and got %b", 
                     passes,fails,passes+fails,
                     expected_value, uart_rx_data);
        end else begin
            fails  = fails  + 1;
            $display("%d/%d/%d [FAIL] Expected %b and got %b", 
                     passes,fails,passes+fails,
                     expected_value, uart_rx_data);
        end
    end
endtask


initial 
begin 
    $dumpfile("waveform.vcd");
    $dumpvars(0,tb);
end 

reg [16:0] input_wires; 
wire [2:0] output_wires ; 

wire reg conv;
wire conv_rd; 
wire sw_mosfet;

 reg busy_rd;
 reg [15:0] dac_input;

wire [2:0] pc ; 


reg [7:0] to_send;
initial begin
    rst=1;
    rst_pin=1; 
    neg_rst = 1; 
    resetn  = 1'b0;
    clk     = 1'b0;
    neg_clk = 1; 
    neg_rst = ~clk ;
    uart_rxd = 1'b1;
    neg_clk = 1'b1; 
    input_wires = 17'b00000000000000111;
    dac_input = 16'h0000;
    busy_rd = 1'b0;
    #4000
    resetn = 1'b1;
    rst=0;
    neg_rst = 0; 
    rst_pin = 0 ; 
    
    #4000
    dac_input = 16'h0000;
    
    @(negedge conv)
     busy_rd = 1'b1;
     #100
     busy_rd = 1'b0;
     dac_input = 16'h0100;
 
     @(negedge conv)
     busy_rd = 1'b1;
     #100
     busy_rd = 1'b0;
     dac_input = 16'h0200;
     
    @(negedge conv)
     busy_rd = 1'b1;
     #100
     busy_rd = 1'b0;
     dac_input = 16'h0300;
     
     @(negedge conv)
     busy_rd = 1'b1;
     #100
     busy_rd = 1'b0;
     dac_input = 16'h0400;
     
     @(negedge conv)
     busy_rd = 1'b1;
     #100
     busy_rd = 1'b0;
     dac_input = 16'h0500;
     
     @(negedge conv)
     busy_rd = 1'b1;
     #100
     busy_rd = 1'b0;
     dac_input = 16'h0600;    
 

    uart_rx_en = 1'b1;
    //@(posedge slow_clk);write_instruction(32'h00000000); 
    //@(posedge slow_clk);write_instruction(32'h00000000); 
    //@(posedge slow_clk);write_instruction(32'hfe010113); 
    //@(posedge slow_clk);write_instruction(32'h00112e23); 
    //@(posedge slow_clk);write_instruction(32'h00812c23); 
    //@(posedge slow_clk);write_instruction(32'h02010413); 
    //@(posedge slow_clk);write_instruction(32'hfe042623); 
    //@(posedge slow_clk);write_instruction(32'hfe042423); 
    //@(posedge slow_clk);write_instruction(32'hfec42703); 
    //@(posedge slow_clk);write_instruction(32'h19000793); 
    //@(posedge slow_clk);write_instruction(32'h04e7ca63); 
    //@(posedge slow_clk);write_instruction(32'h000207b7); 
    //@(posedge slow_clk);write_instruction(32'h00078513); 
    //@(posedge slow_clk);write_instruction(32'h0cc000ef); 
    //@(posedge slow_clk);write_instruction(32'h00200513); 
    //@(posedge slow_clk);write_instruction(32'h198000ef); 
    //@(posedge slow_clk);write_instruction(32'h00000793); 
    //@(posedge slow_clk);write_instruction(32'h00078513); 
    //@(posedge slow_clk);write_instruction(32'h0b8000ef); 
    //@(posedge slow_clk);write_instruction(32'hfe840713); 
    //@(posedge slow_clk);write_instruction(32'hfec40793); 
    //@(posedge slow_clk);write_instruction(32'h00070593); 
    //@(posedge slow_clk);write_instruction(32'h00078513); 
    //@(posedge slow_clk);write_instruction(32'h1e4000ef); 
    //@(posedge slow_clk);write_instruction(32'hfe842703); 
    //@(posedge slow_clk);write_instruction(32'h18f00793); 
    //@(posedge slow_clk);write_instruction(32'hfce7d2e3); 
    //@(posedge slow_clk);write_instruction(32'hfe842703); 
    //@(posedge slow_clk);write_instruction(32'h25800793); 
    //@(posedge slow_clk);write_instruction(32'hfae7cce3); 
    //@(posedge slow_clk);write_instruction(32'hfa9ff06f); 
    //@(posedge slow_clk);write_instruction(32'h00300513); 
    //@(posedge slow_clk);write_instruction(32'h154000ef); 
    //@(posedge slow_clk);write_instruction(32'hf9dff06f); 
    //@(posedge slow_clk);write_instruction(32'hfd010113); 
    //@(posedge slow_clk);write_instruction(32'h02812623); 
    //@(posedge slow_clk);write_instruction(32'h03010413); 
    //@(posedge slow_clk);write_instruction(32'hfca42e23); 
    //@(posedge slow_clk);write_instruction(32'hfff807b7); 
    //@(posedge slow_clk);write_instruction(32'hfff78793); 
    //@(posedge slow_clk);write_instruction(32'hfef42623); 
    //@(posedge slow_clk);write_instruction(32'hfdc42783); 
    //@(posedge slow_clk);write_instruction(32'hfec42703); 
    //@(posedge slow_clk);write_instruction(32'h00ef7f33); 
    //@(posedge slow_clk);write_instruction(32'h00ff6f33); 
    //@(posedge slow_clk);write_instruction(32'h00000013); 
    //@(posedge slow_clk);write_instruction(32'h02c12403); 
    //@(posedge slow_clk);write_instruction(32'h03010113); 
    //@(posedge slow_clk);write_instruction(32'h00008067); 
    //@(posedge slow_clk);write_instruction(32'hfd010113); 
    //@(posedge slow_clk);write_instruction(32'h02812623); 
    //@(posedge slow_clk);write_instruction(32'h03010413); 
    //@(posedge slow_clk);write_instruction(32'hfca42e23); 
    //@(posedge slow_clk);write_instruction(32'hfffc07b7); 
    //@(posedge slow_clk);write_instruction(32'hfff78793); 
    //@(posedge slow_clk);write_instruction(32'hfef42623); 
    //@(posedge slow_clk);write_instruction(32'hfdc42783); 
    //@(posedge slow_clk);write_instruction(32'hfec42703); 
    //@(posedge slow_clk);write_instruction(32'h00ef7f33); 
    //@(posedge slow_clk);write_instruction(32'h00ff6f33); 
    //@(posedge slow_clk);write_instruction(32'h00000013); 
    //@(posedge slow_clk);write_instruction(32'h02c12403); 
    //@(posedge slow_clk);write_instruction(32'h03010113); 
    //@(posedge slow_clk);write_instruction(32'h00008067); 
    //@(posedge slow_clk);write_instruction(32'hfd010113); 
    //@(posedge slow_clk);write_instruction(32'h02812623); 
    //@(posedge slow_clk);write_instruction(32'h03010413); 
    //@(posedge slow_clk);write_instruction(32'hfca42e23); 
    //@(posedge slow_clk);write_instruction(32'hfffe07b7); 
    //@(posedge slow_clk);write_instruction(32'hfff78793); 
    //@(posedge slow_clk);write_instruction(32'hfef42623); 
    //@(posedge slow_clk);write_instruction(32'hfdc42783); 
    //@(posedge slow_clk);write_instruction(32'hfec42703); 
    //@(posedge slow_clk);write_instruction(32'h00ef7f33); 
    //@(posedge slow_clk);write_instruction(32'h00ff6f33); 
    //@(posedge slow_clk);write_instruction(32'h00000013); 
    //@(posedge slow_clk);write_instruction(32'h02c12403); 
    //@(posedge slow_clk);write_instruction(32'h03010113); 
    //@(posedge slow_clk);write_instruction(32'h00008067); 
    //@(posedge slow_clk);write_instruction(32'hfd010113); 
    //@(posedge slow_clk);write_instruction(32'h02812623); 
    //@(posedge slow_clk);write_instruction(32'h03010413); 
    //@(posedge slow_clk);write_instruction(32'hfca42e23); 
    //@(posedge slow_clk);write_instruction(32'hefff07b7); 
    //@(posedge slow_clk);write_instruction(32'hfff78793); 
    //@(posedge slow_clk);write_instruction(32'hfef42623); 
    //@(posedge slow_clk);write_instruction(32'hfdc42783); 
    //@(posedge slow_clk);write_instruction(32'hfec42703); 
    //@(posedge slow_clk);write_instruction(32'h00ef7f33); 
    //@(posedge slow_clk);write_instruction(32'h00ff6f33); 
    //@(posedge slow_clk);write_instruction(32'h00000013); 
    //@(posedge slow_clk);write_instruction(32'h00078513); 
    //@(posedge slow_clk);write_instruction(32'h02c12403); 
    //@(posedge slow_clk);write_instruction(32'h03010113); 
    //@(posedge slow_clk);write_instruction(32'h00008067); 
    //@(posedge slow_clk);write_instruction(32'hfe010113); 
    //@(posedge slow_clk);write_instruction(32'h00812e23); 
    //@(posedge slow_clk);write_instruction(32'h02010413); 
    //@(posedge slow_clk);write_instruction(32'h010f5513); 
    //@(posedge slow_clk);write_instruction(32'h00157793); 
    //@(posedge slow_clk);write_instruction(32'hfef42623); 
    //@(posedge slow_clk);write_instruction(32'hfec42783); 
    //@(posedge slow_clk);write_instruction(32'h00078513); 
    //@(posedge slow_clk);write_instruction(32'h01c12403); 
    //@(posedge slow_clk);write_instruction(32'h02010113); 
    //@(posedge slow_clk);write_instruction(32'h00008067); 
    //@(posedge slow_clk);write_instruction(32'hfe010113); 
    //@(posedge slow_clk);write_instruction(32'h00812e23); 
    //@(posedge slow_clk);write_instruction(32'h02010413); 
    //@(posedge slow_clk);write_instruction(32'h000f5513); 
    //@(posedge slow_clk);write_instruction(32'h0ff57793); 
    //@(posedge slow_clk);write_instruction(32'hfef42623); 
    //@(posedge slow_clk);write_instruction(32'hfec42783); 
    //@(posedge slow_clk);write_instruction(32'h00078513); 
    //@(posedge slow_clk);write_instruction(32'h01c12403); 
    //@(posedge slow_clk);write_instruction(32'h02010113); 
    //@(posedge slow_clk);write_instruction(32'h00008067); 
    //@(posedge slow_clk);write_instruction(32'hfd010113); 
    //@(posedge slow_clk);write_instruction(32'h02812623); 
    //@(posedge slow_clk);write_instruction(32'h03010413); 
    //@(posedge slow_clk);write_instruction(32'hfca42e23); 
    //@(posedge slow_clk);write_instruction(32'hfe042623); 
    //@(posedge slow_clk);write_instruction(32'h0140006f); 
    //@(posedge slow_clk);write_instruction(32'h00000013); 
    //@(posedge slow_clk);write_instruction(32'hfec42783); 
    //@(posedge slow_clk);write_instruction(32'h00178793); 
    //@(posedge slow_clk);write_instruction(32'hfef42623); 
    //@(posedge slow_clk);write_instruction(32'hfdc42683); 
    //@(posedge slow_clk);write_instruction(32'h00068713); 
    //@(posedge slow_clk);write_instruction(32'h00571793); 
    //@(posedge slow_clk);write_instruction(32'h00078713); 
    //@(posedge slow_clk);write_instruction(32'h40d70733); 
    //@(posedge slow_clk);write_instruction(32'h00671793); 
    //@(posedge slow_clk);write_instruction(32'h40e787b3); 
    //@(posedge slow_clk);write_instruction(32'h00379793); 
    //@(posedge slow_clk);write_instruction(32'h00d787b3); 
    //@(posedge slow_clk);write_instruction(32'h00679793); 
    //@(posedge slow_clk);write_instruction(32'h00078713); 
    //@(posedge slow_clk);write_instruction(32'hfec42783); 
    //@(posedge slow_clk);write_instruction(32'hfce7c0e3); 
    //@(posedge slow_clk);write_instruction(32'h00000013); 
    //@(posedge slow_clk);write_instruction(32'h02c12403); 
    //@(posedge slow_clk);write_instruction(32'h03010113); 
    //@(posedge slow_clk);write_instruction(32'h00008067); 
    //@(posedge slow_clk);write_instruction(32'hfd010113); 
    //@(posedge slow_clk);write_instruction(32'h02112623); 
    //@(posedge slow_clk);write_instruction(32'h02812423); 
    //@(posedge slow_clk);write_instruction(32'h03010413); 
    //@(posedge slow_clk);write_instruction(32'hfca42e23); 
    //@(posedge slow_clk);write_instruction(32'hfcb42c23); 
    //@(posedge slow_clk);write_instruction(32'h000807b7); 
    //@(posedge slow_clk);write_instruction(32'h00078513); 
    //@(posedge slow_clk);write_instruction(32'he29ff0ef); 
    //@(posedge slow_clk);write_instruction(32'h00000793); 
    //@(posedge slow_clk);write_instruction(32'h00078513); 
    //@(posedge slow_clk);write_instruction(32'he1dff0ef); 
    //@(posedge slow_clk);write_instruction(32'h000807b7); 
    //@(posedge slow_clk);write_instruction(32'h00078513); 
    //@(posedge slow_clk);write_instruction(32'he11ff0ef); 
    //@(posedge slow_clk);write_instruction(32'h00000013); 
    //@(posedge slow_clk);write_instruction(32'hefdff0ef); 
    //@(posedge slow_clk);write_instruction(32'hfea42423); 
    //@(posedge slow_clk);write_instruction(32'h00100793); 
    //@(posedge slow_clk);write_instruction(32'hfe842703); 
    //@(posedge slow_clk);write_instruction(32'hfef706e3); 
    //@(posedge slow_clk);write_instruction(32'hfe042623); 
    //@(posedge slow_clk);write_instruction(32'h0940006f); 
    //@(posedge slow_clk);write_instruction(32'hfec42783); 
    //@(posedge slow_clk);write_instruction(32'h02079863); 
    //@(posedge slow_clk);write_instruction(32'h000407b7); 
    //@(posedge slow_clk);write_instruction(32'h00078513); 
    //@(posedge slow_clk);write_instruction(32'he19ff0ef); 
    //@(posedge slow_clk);write_instruction(32'hef9ff0ef); 
    //@(posedge slow_clk);write_instruction(32'h00050713); 
    //@(posedge slow_clk);write_instruction(32'hfdc42783); 
    //@(posedge slow_clk);write_instruction(32'h00e7a023); 
    //@(posedge slow_clk);write_instruction(32'h00000793); 
    //@(posedge slow_clk);write_instruction(32'h00078513); 
    //@(posedge slow_clk);write_instruction(32'hdfdff0ef); 
    //@(posedge slow_clk);write_instruction(32'h0540006f); 
    //@(posedge slow_clk);write_instruction(32'hfec42703); 
    //@(posedge slow_clk);write_instruction(32'h00100793); 
    //@(posedge slow_clk);write_instruction(32'h02f71863); 
    //@(posedge slow_clk);write_instruction(32'h000407b7); 
    //@(posedge slow_clk);write_instruction(32'h00078513); 
    //@(posedge slow_clk);write_instruction(32'hde1ff0ef); 
    //@(posedge slow_clk);write_instruction(32'hec1ff0ef); 
    //@(posedge slow_clk);write_instruction(32'h00050713); 
    //@(posedge slow_clk);write_instruction(32'hfd842783); 
    //@(posedge slow_clk);write_instruction(32'h00e7a023); 
    //@(posedge slow_clk);write_instruction(32'h00000793); 
    //@(posedge slow_clk);write_instruction(32'h00078513); 
    //@(posedge slow_clk);write_instruction(32'hdc5ff0ef); 
    //@(posedge slow_clk);write_instruction(32'h01c0006f); 
    //@(posedge slow_clk);write_instruction(32'h000407b7); 
    //@(posedge slow_clk);write_instruction(32'h00078513); 
    //@(posedge slow_clk);write_instruction(32'hdb5ff0ef); 
    //@(posedge slow_clk);write_instruction(32'h00000793); 
    //@(posedge slow_clk);write_instruction(32'h00078513); 
    //@(posedge slow_clk);write_instruction(32'hda9ff0ef); 
    //@(posedge slow_clk);write_instruction(32'hfec42783); 
    //@(posedge slow_clk);write_instruction(32'h00178793); 
    //@(posedge slow_clk);write_instruction(32'hfef42623); 
    //@(posedge slow_clk);write_instruction(32'hfec42703); 
    //@(posedge slow_clk);write_instruction(32'h00700793); 
    //@(posedge slow_clk);write_instruction(32'hf6e7d4e3); 
    //@(posedge slow_clk);write_instruction(32'h00000013); 
    //@(posedge slow_clk);write_instruction(32'h02c12083); 
    //@(posedge slow_clk);write_instruction(32'h02812403); 
    //@(posedge slow_clk);write_instruction(32'h03010113); 
    //@(posedge slow_clk);write_instruction(32'h00008067); 
    //@(posedge slow_clk);write_instruction(32'hffffffff); 
    //@(posedge slow_clk);write_instruction(32'hffffffff); 

     $display("Test Results:");
     $display("    PASSES: %d", passes);
     $display("    FAILS : %d", fails);
    #100000
    $display("Finish simulation at time %d", $time);
    $finish;
end

 wrapper dut (
.clk        (clk          ), // Top level system clock input.
.resetn       (resetn       ), // Asynchronous active low reset.
.uart_rxd     (uart_rxd     ), // UART Recieve pin.
.uart_rx_en   (uart_rx_en   ), // Recieve enable
.uart_rx_break(uart_rx_break), // Did we get a BREAK message?
.uart_rx_valid(uart_rx_valid), // Valid data recieved and available.
.uart_rx_data (uart_rx_data ), 
.CONV (conv), 
.CONV_RD (conv_rd), 
.SW_MOSFET (sw_mosfet), 
.BUSY_RD (busy_rd), 
.ADC_input (dac_input),
.write_done(write_done)
); 



endmodule