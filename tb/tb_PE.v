`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/18 16:44:19
// Design Name: 
// Module Name: tb_PE
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_PE;
    parameter DATA_BITWIDTH = 8;
    parameter NUM_OF_CHANNEL = 1;
    parameter ROM_ADDR_BITWIDTH = 4;
    parameter FIFO_ADDR_BITWIDTH = 4;

    reg clk, rstN, en, we;
    reg[DATA_BITWIDTH-1:0] din;
    wire[2*DATA_BITWIDTH-1:0] dout;

    integer i;

    PE  #(  .DATA_BITWIDTH(DATA_BITWIDTH),
            .NUM_OF_CHANNEL(NUM_OF_CHANNEL),
            .ROM_ADDR_BITWIDTH(ROM_ADDR_BITWIDTH),
            .FIFO_ADDR_BITWIDTH(FIFO_ADDR_BITWIDTH))
    pe      (   .clk(clk), .rstN(rstN), .en(en), .we(we),
                .iact_fifo_in(din), // iact that pushed into the fifo
                .wxi(dout) );// wght x iact

    always #10 clk = ~clk;

    initial begin
        clk = 0; rstN = 1; en = 1; we = 1; din = 0;
        #5 rstN = 0;
        #6 rstN = 1;

        for(i = 0; i < (1 << 8); i = i + 1) begin
            din = i;
            #21;
        end

    end

endmodule
