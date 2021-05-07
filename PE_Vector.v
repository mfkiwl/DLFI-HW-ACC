`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/26 15:21:10
// Design Name: 
// Module Name: PE_Vector
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//      a vector of PEs with B-Adder Tree.
//      This module processes the channel-wise parallel MACs.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PE_Vector #(     parameter DATA_BITWIDTH = 8,
                        parameter NUM_OF_CHANNEL = 32,
                        parameter WEIGHTS_ADDR_BITWIDTH = 4,
                        parameter IACTS_ADDR_BITWIDTH = 4 )
                    (   input clk, rstN, fifo_en, fifo_wea,
                        input [NUM_OF_CHANNEL * DATA_BITWIDTH-1:0] iact, // iacts from FIFO
        	            output[2*DATA_BITWIDTH-1:0] oact  );
    localparam PROD_BITWIDTH = 2 * DATA_BITWIDTH;
    localparam NUM_OF_TREE_NODE = 2 * NUM_OF_CHANNEL - 1;
    integer i;

    wire[NUM_OF_CHANNEL*PROD_BITWIDTH-1:0] psums;
    reg[DATA_BITWIDTH-1:0] psums_tree[0:NUM_OF_TREE_NODE-1];

    // generate PE vector 
    genvar gi;
    generate
        for(gi = 0; gi < NUM_OF_CHANNEL; gi = gi + 1) begin: GEN_PE_VECTOR
            PE #(   .DATA_BITWIDTH(DATA_BITWIDTH),
                    .NUM_OF_CHANNEL(NUM_OF_CHANNEL),
                    .ROM_ADDR_BITWIDTH(WEIGHTS_ADDR_BITWIDTH),
                    .FIFO_ADDR_BITWIDTH(IACTS_ADDR_BITWIDTH)    )
            pe  (
                    .clk(clk), .rstN(rstN), .en(fifo_en), .wea(fifo_wea),
                    .iact_fifo_in(iact[gi * DATA_BITWIDTH + DATA_BITWIDTH - 1 : gi * DATA_BITWIDTH]), // iact that pushed into the fifo
                    .wxi(psums[gi * PROD_BITWIDTH + PROD_BITWIDTH - 1 : gi * PROD_BITWIDTH]) // wght x iact
                );
        end
    endgenerate

    // Build-up the B-adder tree
    
    Binary_Adder_Tree  #(    .DATA_BITWIDTH(PROD_BITWIDTH), .BREADTH_OF_TREE(NUM_OF_CHANNEL)    )
    bat                 (
                            .clk(clk), .rstN(rstN),
                            .din(psums),
                            .sum(oact)
                        );

endmodule
