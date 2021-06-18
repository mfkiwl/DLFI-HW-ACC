`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/23 15:24:30
// Design Name: 
// Module Name: Bottleneck_Layer
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


module Bottleneck_Layer #(  parameter DATA_BITWIDTH = 8,
                            parameter NUM_OF_CHANNEL = 32,
                            parameter NUM_OF_WEIGHT = 32,
                            parameter WEIGHTS_ADDR_BITWIDTH = 4,
                            parameter IACTS_ADDR_BITWIDTH = 4 )
                        (   input[1:0] func,
                            input clk, rstN, 
                            input [NUM_OF_CHANNEL*DATA_BITWIDTH-1:0] iacts, 
                            input [NUM_OF_WEIGHT*NUM_OF_CHANNEL*DATA_BITWIDTH-1:0] wghts,
        	                output[NUM_OF_WEIGHT*DATA_BITWIDTH-1:0] oacts );
    reg[1:0] state;
    wire en_regfile_wght, we_regfile_wght, en_regfile_iact, we_regfile_iact, en_MAC_din, en_MAC_dout;
    wire[IACTS_ADDR_BITWIDTH-1:0] rd_addr_iact, wr_addr_iact;
    wire[WEIGHTS_ADDR_BITWIDTH-1:0] rd_addr_wght,  wr_addr_wght;
    
    Controller  #(  .WEIGHTS_ADDR_BITWIDTH(WEIGHTS_ADDR_BITWIDTH),
                    .IACTS_ADDR_BITWIDTH(IACTS_ADDR_BITWIDTH)   )
    controller  (   .clk(clk), .rstN(rstN),
                    .func(func), .en_MAC_din(en_MAC_din), .en_MAC_dout(en_MAC_dout),
                    .en_regfile_wght(en_regfile_wght), .we_regfile_wght(we_regfile_wght), 
                    .en_regfile_iact(en_regfile_iact), .we_regfile_iact(we_regfile_iact),
                    .rd_addr_iact(rd_addr_iact), .wr_addr_iact(wr_addr_iact), 
                    .rd_addr_wght(rd_addr_wght), .wr_addr_wght(wr_addr_wght)   );
                                

    PE_Matrix    #( .DATA_BITWIDTH(DATA_BITWIDTH),
                    .NUM_OF_CHANNEL(NUM_OF_CHANNEL),
                    .NUM_OF_WEIGHT(NUM_OF_WEIGHT),
                    .WEIGHTS_ADDR_BITWIDTH(WEIGHTS_ADDR_BITWIDTH),
                    .IACTS_ADDR_BITWIDTH(IACTS_ADDR_BITWIDTH)  )
    pem         (   .clk(clk), .rstN(rstN),
                    .en_MAC_din(en_MAC_din), .en_MAC_dout(en_MAC_dout),
                    .en_regfile_wght(en_regfile_wght), .we_regfile_wght(we_regfile_wght), 
                    .en_regfile_iact(en_regfile_iact), .we_regfile_iact(we_regfile_iact),
                    .iacts(iacts),
                    .wghts(wghts),
                    .rd_addr_iact(rd_addr_iact), .wr_addr_iact(wr_addr_iact),
                    .rd_addr_wght(rd_addr_wght), .wr_addr_wght(wr_addr_wght),
        	        .oacts(oacts) );

endmodule
