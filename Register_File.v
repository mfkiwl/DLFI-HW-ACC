`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/26 15:49:39
// Design Name: 
// Module Name: Register_File
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


module Register_File #( parameter DATA_BITWIDTH = 8, parameter ADDR_BITWIDTH = 4) 
                    (   input clk, rstN, en, we,
                        input[DATA_BITWIDTH-1:0] din,
                        input[ADDR_BITWIDTH-1:0] rd_addr, wr_addr,
                        output[DATA_BITWIDTH-1:0] dout );
    integer i;

    reg[DATA_BITWIDTH-1:0] memory[0:(1 << ADDR_BITWIDTH)-1];

    assign dout = en ? memory[rd_addr] : {DATA_BITWIDTH{1'bz}};
    always @(posedge clk, negedge rstN) begin
        if(!rstN) begin: RESET
            for(i = 0; i < (1 << ADDR_BITWIDTH); i = i + 1)
               memory[i] <= 0;
        end 
        else begin
            if (!en && we) begin: WRITE
                memory[wr_addr] <= din;
            end
        end
    end

endmodule
