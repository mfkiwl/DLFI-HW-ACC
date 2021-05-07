`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/26 16:10:28
// Design Name: 
// Module Name: FIFO
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
// clk  : Clock 
// rstN : Negative Reset
// en   : Read Enable
// wea  : Write Enable
// din  : input data
// dout : output data
//////////////////////////////////////////////////////////////////////////////////


module FIFO #(  parameter DATA_BITWIDTH = 8,
                parameter ADDR_BITWIDTH = 4)  
            (   input clk, rstN, en, wea,
                input[DATA_BITWIDTH-1:0] din,
                output reg[DATA_BITWIDTH-1:0] dout  );
    integer i; // assure that loop-exceed is never occurred

    reg[ADDR_BITWIDTH-1:0] wr_addr;
    reg[ADDR_BITWIDTH-1:0] rd_addr;
    reg[DATA_BITWIDTH-1:0] memory[0:(1 << ADDR_BITWIDTH)-1];

    always @(posedge clk, negedge rstN) begin
        if(!rstN) begin
            for(i = 0; i < (1 << ADDR_BITWIDTH); i = i + 1) begin
                memory[i] <= 0;
            end
            wr_addr <= 0;
            rd_addr <= 0;
        end
        else begin
            case({en, wea}) 
            2'b00 : begin end
            2'b01 : begin // write to fifo (enqueue)
                        memory[wr_addr] <= din;
                        wr_addr <= wr_addr + 1;
                    end
            2'b10 : begin // read from fifo (dequeue) *NOTE : Not sure that clearing memory cell is required.
                        dout <= memory[rd_addr];
                        rd_addr <= rd_addr + 1;
                    end
            2'b11 : begin // read & write concurrently
                        memory[wr_addr] <= din;
                        wr_addr <= wr_addr + 1;
                        dout <= memory[rd_addr];
                        rd_addr <= rd_addr + 1;
                    end
            endcase
        end
    end
    

endmodule
