`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/13 12:37:03
// Design Name: 
// Module Name: tb_FIFO
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


module tb_FIFO;
    parameter DATA_BITWIDTH = 8;
    parameter ADDR_BITWIDTH = 4;

    integer i;
    reg clk, rstN, en, we;
    reg[DATA_BITWIDTH-1:0] din;
    wire[DATA_BITWIDTH-1:0] dout;

    FIFO    #(  .DATA_BITWIDTH(DATA_BITWIDTH),
                .ADDR_BITWIDTH(ADDR_BITWIDTH)  )  
    fifo    (   .clk(clk), .rstN(rstN), .en(en), .we(we),
                .din(din),
                .dout(dout)  );

    always #10 clk = ~clk;

    initial begin
        clk = 0; rstN = 1; en = 0; we = 0; i = 0;
    #5  rstN = 0;
    #5  rstN = 1; en = 1; we = 1; 
        for(i = 0; i < 65536; i = i + 1) begin
            din = i;
        #20;
        end
    end

endmodule
