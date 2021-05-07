`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/06 17:21:33
// Design Name: 
// Module Name: Binary_Adder_Tree
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


module Binary_Adder_Tree #(  parameter DATA_BITWIDTH = 8,
                        parameter BREADTH_OF_TREE = 32
                    )
                    (
                        input clk, rstN,
                        input[DATA_BITWIDTH*BREADTH_OF_TREE-1:0] din,
                        output[DATA_BITWIDTH-1:0] sum
                    );
    localparam NUM_OF_NODES = 2 * BREADTH_OF_TREE - 1;

    wire[DATA_BITWIDTH-1:0] w_din[0:BREADTH_OF_TREE-1];
    reg[DATA_BITWIDTH-1:0] nodes[0:NUM_OF_NODES-1];
    
    assign sum = nodes[NUM_OF_NODES - 1];

    genvar gi;
    generate
        for(gi = 0; gi < BREADTH_OF_TREE; gi = gi + 1) begin: VECTOR_TO_ARRAY
            assign w_din[gi] = din[(gi * DATA_BITWIDTH) + DATA_BITWIDTH - 1 : gi * DATA_BITWIDTH];
        end
    endgenerate
    
    integer i;
    always @(posedge clk, negedge rstN) begin
        if(!rstN) begin
            for(i = 0; i < NUM_OF_NODES; i = i + 1) begin: INIT_ALL
                nodes[i] <= 0;
            end
        end
        else begin
            for(i = 0; i < BREADTH_OF_TREE; i = i + 2) begin: LEAVES_OF_TREE
                // fetch input data into leaf registers
                nodes[i] <= w_din[i];
                nodes[i + 1] <= w_din[i + 1];
            end
            for(i = 0; i < NUM_OF_NODES - 1; i = i + 2) begin: PARENTS_OF_LEAVES
                // sum and send to the next stage
                nodes[BREADTH_OF_TREE + i / 2] <= nodes[i] + nodes[i + 1];
            end
        end
    end

endmodule
