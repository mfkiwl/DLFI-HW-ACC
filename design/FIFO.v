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
// we  : Write Enable
// din  : input data
// dout : output data
//////////////////////////////////////////////////////////////////////////////////


module FIFO #(  parameter DATA_BITWIDTH = 8,
                parameter ADDR_BITWIDTH = 4)  
            (   input clk, rstN, en, we,
                input[DATA_BITWIDTH-1:0] din,
                output reg[DATA_BITWIDTH-1:0] dout  );
    localparam DEPTH = 1 << ADDR_BITWIDTH;
    integer i; 

    reg[ADDR_BITWIDTH-1:0] wr_ptr;
    reg[ADDR_BITWIDTH-1:0] rd_ptr;
    reg[DATA_BITWIDTH-1:0] memory[0:DEPTH-1];

    wire full, empty;
    assign full = (wr_ptr - rd_ptr) == DEPTH ? 1'b1 : 1'b0;
    assign empty = (wr_ptr - rd_ptr) == 0 ? 1'b1 : 1'b0;

    always @(posedge clk, negedge rstN) begin
        if(!rstN) begin
            for(i = 0; i < DEPTH; i = i + 1) begin
                memory[i] <= 0;
            end
            wr_ptr <= 0;
            rd_ptr <= 0;
        end
        else begin
            case({en, we}) 
            2'b00 :;
            2'b01 : begin // write to fifo (enqueue)
                        if(!full) begin
                            memory[wr_ptr] <= din;
                            wr_ptr <= wr_ptr + 1;
                        end
                    end
            2'b10 : begin // read from fifo (dequeue) *NOTE : Not sure that clearing memory cell is required.
                        if(!empty) begin
                            dout <= memory[rd_ptr];
                            rd_ptr <= rd_ptr + 1;
                        end
                    end
            2'b11 : begin // read & write concurrently
                        if(!full) begin
                            memory[wr_ptr] <= din;
                            wr_ptr <= wr_ptr + 1;
                        end
                        if(!empty) begin
                            dout <= memory[rd_ptr];
                            rd_ptr <= rd_ptr + 1;
                        end
                    end
            endcase
        end
    end

endmodule
