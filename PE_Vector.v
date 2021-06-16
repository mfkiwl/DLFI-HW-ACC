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

// Need a PSum buffer because the output of this module is only just a psum of channel-direction MACs. 

module PE_Vector #(     parameter DATA_BITWIDTH = 8,
                        parameter NUM_OF_CHANNEL = 32,
                        parameter WEIGHTS_ADDR_BITWIDTH = 4,
                        parameter IACTS_ADDR_BITWIDTH = 4 )
                    (   input clk, rstN, en_regfile_wght, we_regfile_wght, en_MAC_din, en_MAC_dout,
                        input [NUM_OF_CHANNEL * DATA_BITWIDTH-1:0] iact, 
                        input [NUM_OF_CHANNEL * DATA_BITWIDTH-1:0] wght, 
                        input[WEIGHTS_ADDR_BITWIDTH-1:0] rd_addr_wght, wr_addr_wght,
        	            output[DATA_BITWIDTH-1:0] oact  );
    localparam PROD_BITWIDTH = 32;

    wire[NUM_OF_CHANNEL*PROD_BITWIDTH-1:0] psums;
    wire[DATA_BITWIDTH-1:0] w_wght[0:NUM_OF_CHANNEL-1];

    // generate PE vector   
    genvar gi;
    generate
        for(gi = 0; gi < NUM_OF_CHANNEL; gi = gi + 1) begin: GEN_PE_VECTOR

            assign w_wght[gi] = wght[gi * DATA_BITWIDTH +: DATA_BITWIDTH];

            PE #(   .DATA_BITWIDTH(DATA_BITWIDTH),
                    .NUM_OF_CHANNEL(NUM_OF_CHANNEL),
                    .ROM_ADDR_BITWIDTH(WEIGHTS_ADDR_BITWIDTH),
                    .FIFO_ADDR_BITWIDTH(IACTS_ADDR_BITWIDTH)    )
            pe  (   .clk(clk), .rstN(rstN), 
                    .en_regfile_wght(en_regfile_wght), .we_regfile_wght(we_regfile_wght), 
                    .en_MAC_din(en_MAC_din), .en_MAC_dout(en_MAC_dout),
                    .iact(iact[gi * DATA_BITWIDTH +: DATA_BITWIDTH]), 
                    .wght_regfile_in(w_wght[gi]),
                    .rd_addr_regfile(rd_addr_wght), .wr_addr_regfile(wr_addr_wght),
                    .psum(psums[gi * PROD_BITWIDTH +: PROD_BITWIDTH])    ); // psum of single channel
        end
    endgenerate

    // Build-up the B-adder tree
    Binary_Adder_Tree  #(   .DATA_BITWIDTH(DATA_BITWIDTH), .BREADTH_OF_TREE(NUM_OF_CHANNEL)    )
    bat                 (   .clk(clk), .rstN(rstN),
                            .din(psums),
                            .sum(oact)  );

endmodule
