`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/04 15:35:09
// Design Name: 
// Module Name: Controller
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


module Controller   #(  parameter WEIGHTS_ADDR_BITWIDTH = 4,
                        parameter IACTS_ADDR_BITWIDTH = 5   )
                    (   input clk, rstN,
                        input[1:0] func,
                        output reg en_MAC_din, en_MAC_dout,
                        output reg en_regfile_wght, we_regfile_wght, 
                        output reg en_regfile_iact, we_regfile_iact,
                        output reg[IACTS_ADDR_BITWIDTH-1:0] rd_addr_iact, wr_addr_iact, 
                        output reg[WEIGHTS_ADDR_BITWIDTH-1:0] rd_addr_wght, wr_addr_wght   );
    
    localparam INIT = 2'b01;
    localparam RUN = 2'b10;
    localparam COMPLETE = 2'b11;

    localparam PADDING = 3;
    localparam IW = 3;
    localparam PADDED_IW = 9;
    localparam KK = 49;
    localparam K = 7;

    reg[15:0] count;
    reg[1:0] state;

    reg[15:0] offset_row_rd_addr_iact, offset_col_rd_addr_iact;
    reg[15:0] row_counter;

    always @(posedge clk, negedge rstN) begin
        if (!rstN) begin
            {en_MAC_din, en_MAC_dout, en_regfile_wght, we_regfile_wght, en_regfile_iact, we_regfile_iact} <= 6'b000000;
            rd_addr_iact <= 0;
            rd_addr_wght <= 0;
            wr_addr_iact <= 0;
            wr_addr_wght <= 0;
            count <= 0;
            state <= INIT;
            offset_row_rd_addr_iact <= 0;
            offset_col_rd_addr_iact <= 0;
            row_counter <= 0;
        end
        else begin
            case (state)
            INIT: begin
                {en_MAC_din, en_MAC_dout, en_regfile_wght, we_regfile_wght, en_regfile_iact, we_regfile_iact} <= 6'b000101; 
                if (count < KK) begin
                    count <= count + 1;
                    wr_addr_wght <= count;
                    if (count < 9)
                        wr_addr_iact <= (PADDED_IW) * (PADDING + (count / PADDING)) + PADDING + (count % PADDING);
                end
                else begin
                    wr_addr_iact <= 0;
                    wr_addr_wght <= 0;
                    count <= 1;
                    state <= RUN;
                    {en_MAC_din, en_MAC_dout, en_regfile_wght, we_regfile_wght, en_regfile_iact, we_regfile_iact} <= 6'b101010;
                    rd_addr_iact <= 0;
                    rd_addr_wght <= 0;
                end
            end

            RUN: begin
                rd_addr_iact <= (PADDED_IW * (offset_row_rd_addr_iact + row_counter)) + (offset_col_rd_addr_iact + count);
                rd_addr_wght <= (K * row_counter) + count;
                if (count < K - 1) begin // count는 0~6을  반복
                    en_MAC_dout <= 0;
                    count <= count + 1;
                end
                else begin // count == 6이 되면 다음 행 처리
                    count <= 0;
                    if (row_counter < K - 1) begin
                        row_counter <= row_counter + 1;
                    end
                    else begin
                        en_MAC_dout <= 1;
                        row_counter <= 0;
                        if (offset_col_rd_addr_iact < PADDED_IW - K) begin
                            offset_col_rd_addr_iact <= offset_col_rd_addr_iact + 1;
                        end
                        else begin
                            offset_col_rd_addr_iact <= 0;
                            if(offset_row_rd_addr_iact < PADDED_IW - K) begin
                                offset_row_rd_addr_iact <= offset_row_rd_addr_iact + 1;
                            end
                            else begin
                                offset_row_rd_addr_iact <= 0;
                                state <= COMPLETE;
                                // {en_MAC_din, en_MAC_dout, en_regfile_wght, we_regfile_wght, en_regfile_iact, we_regfile_iact} <= 6'b000000;
                            end
                        end
                    end
                end
            end
            COMPLETE: begin
                {en_MAC_din, en_MAC_dout, en_regfile_wght, we_regfile_wght, en_regfile_iact, we_regfile_iact} <= 6'b000000;
            end
            default: begin
            end
            endcase
        end
    end

endmodule
