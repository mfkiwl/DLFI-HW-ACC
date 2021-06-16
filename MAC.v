`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/03 12:21:02
// Design Name: 
// Module Name: MAC
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Pipelined-MAC
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MAC  #(  parameter  DATA_BITWIDTH = 8 )  
            (   input clk, rstN, en_MAC_din, en_MAC_dout,
                input [DATA_BITWIDTH-1:0] iact, // in1 = activations, in2 = weight 
	            input [DATA_BITWIDTH-1:0] wght,
	            output reg [31:0] dout    );
    localparam KERNEL_SIZE = 7 * 7;

    reg r_en_MAC_dout;
    reg[31:0] r_iact; 
    reg[31:0] r_wght; 
    reg[31:0] r_psum; 

    always @(posedge clk, negedge rstN) begin
        if(!rstN) begin 
            r_iact <= 0;
            r_wght <= 0;
            r_psum <= 0;
            dout <= 0;
            r_en_MAC_dout <= 0;
        end
        else begin
            r_en_MAC_dout <= en_MAC_dout;
            if(en_MAC_din) begin
                r_iact <= iact;
                r_wght[DATA_BITWIDTH-1:0] <= wght;
                r_wght[31:DATA_BITWIDTH] <= {(32-DATA_BITWIDTH){wght[DATA_BITWIDTH - 1]}};
                r_psum <= r_psum + r_iact * r_wght;
            end
            if (r_en_MAC_dout) begin
                dout <= r_psum;
                r_psum <= 0;
            end
            else dout <= dout;
        end
    end
/*
    integer fo;
    wire signed[31:0] tmp;
    assign tmp = r_iact * r_wght;
    always @(posedge clk) begin
        fo = $fopen("../../../MAC.txt");
        $fmonitor(fo, "[%m] %d ns: %d * %d = %d", $realtime, r_iact, r_wght , tmp);
    end
*/
endmodule
