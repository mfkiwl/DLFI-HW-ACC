`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/22 15:16:33
// Design Name: 
// Module Name: tb_Bottleneck_Layer
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
//  Simulation of receiving and processing data from the encoder layer.
//  Depending on the handshake signal 'request_next_iact', 
//  it is decided whether to receive or hold data.
//////////////////////////////////////////////////////////////////////////////////

module tb_Bottleneck_Layer;
    localparam DATA_BITWIDTH = 8;
    localparam PROD_BITWIDTH = 2 * DATA_BITWIDTH;
    localparam KW = 3;
    localparam KH = 3;
    localparam NUM_OF_CHANNEL = 32;
    localparam NUM_OF_WEIGHT = 32;
    localparam DILATION = 3;
    localparam DILATED_KW = (KW-1) * (DILATION-1) + KW;
    localparam DILATED_KH = (KH-1) * (DILATION-1) + KH;
    localparam WEIGHTS_ADDR_BITWIDTH = $clog2(DILATED_KW * DILATED_KH) + 1;
    localparam IACTS_ADDR_BITWIDTH = 5;
    reg clk, rstN;
    wire request_next_iact;
    wire[DATA_BITWIDTH * NUM_OF_WEIGHT-1:0] w_oacts; // output port of bottleneck layer

    // these registers are registering the result of S/W reference code and can be compared with verilog's output.
    reg[DATA_BITWIDTH-1:0] iact_register[0:9*NUM_OF_CHANNEL-1];
    reg[DATA_BITWIDTH-1:0] oact_register[0:9*NUM_OF_CHANNEL-1];
    reg[DATA_BITWIDTH-1:0] wght_register[0:NUM_OF_WEIGHT*DILATED_KW*DILATED_KW*NUM_OF_CHANNEL-1];

    wire[NUM_OF_CHANNEL*DATA_BITWIDTH-1:0] iact_concat_by_chan[0:8];
    wire[NUM_OF_WEIGHT*NUM_OF_CHANNEL*DATA_BITWIDTH-1:0] wght_concat_by_chan[0:48];
    wire[DATA_BITWIDTH-1:0] divided_oacts[0:NUM_OF_WEIGHT - 1];
    reg[NUM_OF_CHANNEL*DATA_BITWIDTH-1:0] iacts; 
    reg[NUM_OF_WEIGHT*NUM_OF_CHANNEL*DATA_BITWIDTH-1:0] wghts; 
    reg[DATA_BITWIDTH-1:0] oacts[0:9*NUM_OF_CHANNEL-1]; 

    genvar gi, gj, gk;

    generate
        for(gi = 0; gi < NUM_OF_WEIGHT; gi = gi + 1) begin
            assign divided_oacts[gi] = w_oacts[gi * DATA_BITWIDTH +: DATA_BITWIDTH];
        end
    endgenerate

    generate // concat iact
        for(gj = 0; gj < 288; gj = gj + 1) begin
            // little endian
            // assign iact_concat_by_chan[gj % 9][DATA_BITWIDTH * (gj / 9) +: DATA_BITWIDTH] = iact_register[gj];
            // big endian
            assign iact_concat_by_chan[gj % 9][((NUM_OF_CHANNEL * DATA_BITWIDTH - 1) - DATA_BITWIDTH * (gj / 9)) -: DATA_BITWIDTH] = iact_register[gj];
        end
    endgenerate

    generate // concat weight
        for(gk = 0; gk < 50176; gk = gk + 1) begin
            // assign wght_concat_by_chan[gk % 49][NUM_OF_CHANNEL * DATA_BITWIDTH * (gk / 49) +: DATA_BITWIDTH] = wght_register[gk];
            assign wght_concat_by_chan[gk % 49][((NUM_OF_WEIGHT * NUM_OF_CHANNEL * DATA_BITWIDTH - 1) - DATA_BITWIDTH * (gk / 49)) -: DATA_BITWIDTH] = wght_register[gk];
        end
    endgenerate

    // iact = 채널 별로 묶인 각 픽셀
    Bottleneck_Layer    #(  .DATA_BITWIDTH(DATA_BITWIDTH),
                            .NUM_OF_CHANNEL(NUM_OF_CHANNEL),
                            .NUM_OF_WEIGHT(NUM_OF_WEIGHT),
                            .WEIGHTS_ADDR_BITWIDTH(WEIGHTS_ADDR_BITWIDTH),
                            .IACTS_ADDR_BITWIDTH(7))
    uut                 (   .func(func),
                            .clk(clk), .rstN(rstN), 
                            .iacts(iacts), 
                            .wghts(wghts),
                            .request_next_iact(request_next_iact),
        	                .oacts(w_oacts) );

    always #10 clk = ~clk;

    initial begin
        $readmemh("/home/s-lee/CIS/repos/DLFI-HW-ACC/dat_aspp/[3x3x32] aspp_input_1_h.mem", iact_register);
        $readmemh("/home/s-lee/CIS/repos/DLFI-HW-ACC/dat_aspp/[3x3x32] aspp_output_h.mem", oact_register);
        $readmemh("/home/s-lee/CIS/repos/DLFI-HW-ACC/dat_aspp/[32x7x7x32] aspp3_w_h_zeros.mem", wght_register);
        // $stop;
        clk = 0; rstN = 1; 
        #10 rstN = 0;
        #10 rstN = 1; 
    end

    integer i;
    initial begin
        for(i = 0; i < 9; i = i + 1) begin
            #20 iacts = iact_concat_by_chan[i];
        end
        
        #200 $readmemh("/home/s-lee/CIS/repos/DLFI-HW-ACC/dat_aspp/[3x3x32] aspp_input_2_h.mem", iact_register);
        for(i = 0; i < 9; i = i + 1) begin
            #20 iacts = iact_concat_by_chan[i];
        end
    end

    integer j;
    initial begin
        for(j = 9; j < 49; j = j + 1) begin
            #20 wghts = wght_concat_by_chan[j];
        end
    end
    

endmodule
