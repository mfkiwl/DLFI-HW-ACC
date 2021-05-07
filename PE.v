`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/05 17:05:26
// Design Name: 
// Module Name: PE
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Processing Engine. 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PE   #(  parameter DATA_BITWIDTH = 8,
                parameter NUM_OF_CHANNEL = 32,
                parameter ROM_ADDR_BITWIDTH = 4,
                parameter FIFO_ADDR_BITWIDTH = 4)
            (
                input clk, rstN, en, wea,
                input[DATA_BITWIDTH-1:0] iact_fifo_in, // iact that pushed into the fifo
                output[(2*DATA_BITWIDTH)-1:0] wxi // wght x iact
            );
    localparam PROD_BITWIDTH = 2 * DATA_BITWIDTH;
    
    wire[DATA_BITWIDTH-1:0] wght; // wght from ROM
    wire[DATA_BITWIDTH-1:0] iact; // iact from FIFO

    FIFO       #(  .DATA_BITWIDTH(DATA_BITWIDTH), .ADDR_BITWIDTH(FIFO_ADDR_BITWIDTH)  )  
    iact_fifo   (   .clk(clk), .rstN(rstN), .en(), .wea(),
                    .din(iact_fifo_in),
                    .dout(iact) );

    ROM        #(  .DATA_BITWIDTH(DATA_BITWIDTH), .ADDR_BITWIDTH(ROM_ADDR_BITWIDTH)) 
    wght_rom    (   .clk(clk), .rstN(rstN), .en(), 
                    .dout(wght) );

    Multiplier #(.DATA_BITWIDTH(DATA_BITWIDTH))
    multiplier  (   .clk(clk), .rstN(rstN),
                    .iact(iact), // in1 = activations, in2 = weight 
	                .wght(wght),
	                .dout(wxi)    );

endmodule
