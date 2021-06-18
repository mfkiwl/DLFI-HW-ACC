`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/03 16:20:31
// Design Name: 
// Module Name: tb_MAC
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


module tb_MAC;
    parameter  DATA_BITWIDTH = 8;
    localparam PROD_BITWIDTH = 2 * DATA_BITWIDTH;
    localparam KERNEL_SIZE = 3 * 3;

    reg clk, rstN;
    reg[DATA_BITWIDTH-1:0] iact;
    reg[DATA_BITWIDTH-1:0] wght;
    wire[PROD_BITWIDTH-1:0] dout;


    MAC #(.DATA_BITWIDTH(DATA_BITWIDTH))  
    mac (   .clk(clk), .rstN(rstN),
            .iact(iact), // in1 = activations, in2 = weight 
	        .wght(wght),
	        .dout(dout)    );

    always #10 clk = ~clk;

    initial begin
        clk = 0; rstN = 1;
        iact = 1; wght = 9;
        #10 rstN = 0;
        #10 rstN = 1;
        
        #20 iact = 2; wght = 8;
        #20 iact = 3; wght = 7;
        #20 iact = 4; wght = 6;
        #20 iact = 5; wght = 5;
        #20 iact = 6; wght = 4;
        #20 iact = 7; wght = 3;
        #20 iact = 8; wght = 2;
        #20 iact = 9; wght = 1;

        #20 iact = 5; wght = 1;
        #20 iact = 4; wght = 2;
        #20 iact = 5; wght = 3;
        #20 iact = 4; wght = 1;
        #20 iact = 5; wght = 2;
        #20 iact = 4; wght = 3;
        #20 iact = 5; wght = 1;
        #20 iact = 4; wght = 2;
        #20 iact = 5; wght = 3;

    end

endmodule
