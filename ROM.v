`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/26 15:49:39
// Design Name: 
// Module Name: ROM
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


module ROM #(   parameter DATA_BITWIDTH = 8, parameter ADDR_BITWIDTH = 4) 
            (   input clk, input rstN, input en, 
                output reg[DATA_BITWIDTH-1:0] dout );
    integer i;
    
    reg[ADDR_BITWIDTH-1:0] read_addr;
    
    (*rom_style = "block" *)
    reg[DATA_BITWIDTH-1:0] memory[0:(1 << ADDR_BITWIDTH)-1];
    
    always @(posedge clk, negedge rstN) begin
        if(!rstN) begin
            read_addr <= 0;
            for(i = 0; i < (1 << ADDR_BITWIDTH); i = i + 1) begin
               memory[i] <= 0;
            end
        end 
        else begin
            if(en) begin
                dout <= memory[read_addr];
                read_addr <= read_addr + 1;
            end
        end
    end

endmodule
