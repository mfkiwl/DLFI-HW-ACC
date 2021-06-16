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
            (   input clk, rstN, en_regfile_wght, we_regfile_wght, en_MAC_din, en_MAC_dout,
                input[DATA_BITWIDTH-1:0] iact, // iact that pushed into the fifo
                input[DATA_BITWIDTH-1:0] wght_regfile_in,
                input[ROM_ADDR_BITWIDTH-1:0] rd_addr_regfile, wr_addr_regfile,
                output[31:0] psum );// psum
            
    wire[DATA_BITWIDTH-1:0] w_wght; // wght from ROM
    wire[DATA_BITWIDTH-1:0] w_iact; // iact from FIFO
    
    assign w_iact = iact;
    Register_File   #(  .DATA_BITWIDTH(DATA_BITWIDTH), .ADDR_BITWIDTH(ROM_ADDR_BITWIDTH)) 
    regfile_wght    (   .clk(clk), .rstN(rstN), .en(en_regfile_wght), .we(we_regfile_wght),
                        .din(wght_regfile_in), 
                        .rd_addr(rd_addr_regfile), .wr_addr(wr_addr_regfile),
                        .dout(w_wght) );

    MAC #(  .DATA_BITWIDTH(DATA_BITWIDTH))
    mac (   .clk(clk), .rstN(rstN),
            .en_MAC_din(en_MAC_din), .en_MAC_dout(en_MAC_dout),
            .iact(w_iact), // in1 = activations, in2 = weight 
	        .wght(w_wght),
	        .dout(psum)    );

endmodule
