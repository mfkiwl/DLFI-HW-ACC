`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/11 13:59:17
// Design Name: 
// Module Name: ReLU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
//  Rectified-Linear Unit.
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ReLU #(  parameter DATA_BITWIDTH = 8 )
            (   input[31:0] din,
                output[DATA_BITWIDTH-1:0] dout  );
    wire[31:0] w_dout;

    assign w_dout = din[31] ? {31{1'b0}} : din >> 6;
    assign dout = w_dout > 255 ? {DATA_BITWIDTH{1'b1}} : w_dout[DATA_BITWIDTH-1:0];

endmodule
