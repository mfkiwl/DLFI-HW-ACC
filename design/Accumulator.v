`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/23 16:53:37
// Design Name: 
// Module Name: Accumulator
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


module Accumulator  #(  parameter DATA_BITWIDTH = 8 )
                    (   input clk, rstN, en,
                        input[DATA_BITWIDTH-1:0] din,
                        output reg[31:0] dout   );

    reg[31:0] psum, count;
    always @(posedge clk, negedge rstN) begin
        if(!rstN) begin 
            psum <= 0;
            count <= 0;
        end
        else begin
            if(count == 9) begin
            end
            else begin
                psum <= psum + din;
                count <= count + 1;
            end

        end
    end

endmodule
