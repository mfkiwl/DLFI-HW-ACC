`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/03 12:21:02
// Design Name: 
// Module Name: Multiplier
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Pipelined-Multiplier
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Multiplier   #(  parameter  DATA_BITWIDTH = 8 )  
                    (   input clk, rstN,
                        input [DATA_BITWIDTH-1:0] iact, // in1 = activations, in2 = weight 
	                    input [DATA_BITWIDTH-1:0] wght,
	                    output [(2*DATA_BITWIDTH)-1:0] dout    );
    localparam PROD_BITWIDTH = 2 * DATA_BITWIDTH;

    reg[DATA_BITWIDTH-1:0] r_psum; 
    reg[DATA_BITWIDTH-1:0] r_iact; 
    reg[DATA_BITWIDTH-1:0] r_wght; 
    reg[PROD_BITWIDTH-1:0] r_mult;

    always @(posedge clk, negedge rstN) begin
        if(!rstN) begin
            r_psum <= 0;
            r_iact <= 0;
            r_wght <= 0;
            r_mult <= 0;
        end
        else begin
            r_iact <= iact;
            r_wght <= wght;
            r_mult <= r_iact * r_wght;
        end
    end

    assign dout = r_mult;

endmodule
