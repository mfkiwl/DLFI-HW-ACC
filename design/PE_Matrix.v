`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/06 16:16:34
// Design Name: 
// Module Name: PE_Matrix
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//      2D Matrix of PEs consists of 1D PE vectors.
//      This module convolves multiple weights in parallel.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PE_Matrix #(  parameter DATA_BITWIDTH = 8,
                    parameter NUM_OF_CHANNEL = 32,
                    parameter NUM_OF_WEIGHT = 32,
                    parameter WEIGHTS_ADDR_BITWIDTH = 4,
                    parameter IACTS_ADDR_BITWIDTH = 5 )
                (   input clk, rstN, en_MAC_din, en_MAC_dout,
                    input en_regfile_wght, we_regfile_wght, en_regfile_iact, we_regfile_iact,
                    input[NUM_OF_CHANNEL*DATA_BITWIDTH-1:0] iacts, 
                    input[NUM_OF_WEIGHT*NUM_OF_CHANNEL*DATA_BITWIDTH-1:0] wghts,
                    input[IACTS_ADDR_BITWIDTH-1:0] rd_addr_iact, wr_addr_iact,
                    input[WEIGHTS_ADDR_BITWIDTH-1:0] rd_addr_wght, wr_addr_wght,
        	        output[NUM_OF_WEIGHT*DATA_BITWIDTH-1:0] oacts );
                
    reg[NUM_OF_CHANNEL*DATA_BITWIDTH-1:0] r_wght[0:NUM_OF_WEIGHT-1];
    reg[DATA_BITWIDTH-1:0] r_iacts_din[0:NUM_OF_CHANNEL-1];
    wire[NUM_OF_CHANNEL*DATA_BITWIDTH-1:0] w_iacts_dout_concat;
    wire[DATA_BITWIDTH-1:0] w_oact[0:NUM_OF_WEIGHT-1];
    wire[DATA_BITWIDTH-1:0] w_iacts_dout[0:NUM_OF_CHANNEL-1];

    genvar gi;
    generate
        for (gi = 0; gi < NUM_OF_CHANNEL; gi = gi + 1) begin : GEN_IACT_REGISTER_FILE
            always @(posedge clk) r_iacts_din[gi] <= iacts[gi * DATA_BITWIDTH +: DATA_BITWIDTH];
            assign w_iacts_dout_concat[gi * DATA_BITWIDTH +: DATA_BITWIDTH] = w_iacts_dout[gi];
            
            Register_File   #(  .DATA_BITWIDTH(DATA_BITWIDTH), .ADDR_BITWIDTH(IACTS_ADDR_BITWIDTH)) 
            regfile_iact    (   .clk(clk), .rstN(rstN), .en(en_regfile_iact), .we(we_regfile_iact),
                                .din(r_iacts_din[gi]),
                                .rd_addr(rd_addr_iact), .wr_addr(wr_addr_iact),
                                .dout(w_iacts_dout[gi]) );
        end
    endgenerate

    genvar gj;
    generate
        for(gj = 0; gj < NUM_OF_WEIGHT; gj = gj + 1) begin: GEN_PE_MATRIX
            always @(posedge clk) r_wght[gj] = wghts[gj * NUM_OF_CHANNEL * DATA_BITWIDTH +: NUM_OF_CHANNEL * DATA_BITWIDTH];
            assign oacts[gj * DATA_BITWIDTH +: DATA_BITWIDTH] = w_oact[gj];

            PE_Vector   #(  .DATA_BITWIDTH(DATA_BITWIDTH),
                            .NUM_OF_CHANNEL(NUM_OF_CHANNEL),
                            .WEIGHTS_ADDR_BITWIDTH(WEIGHTS_ADDR_BITWIDTH),
                            .IACTS_ADDR_BITWIDTH(IACTS_ADDR_BITWIDTH) )
            pe_vector   (   .clk(clk), .rstN(rstN), 
                            .en_regfile_wght(en_regfile_wght), .we_regfile_wght(we_regfile_wght),
                            .en_MAC_din(en_MAC_din), .en_MAC_dout(en_MAC_dout),
                            .iact(w_iacts_dout_concat), 
                            .wght(r_wght[gj]),
                            .rd_addr_wght(rd_addr_wght), .wr_addr_wght(wr_addr_wght),
        	                .oact(w_oact[gj])  );
        end
    endgenerate

endmodule
