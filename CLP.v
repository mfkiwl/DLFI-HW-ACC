`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/25 15:36:09
// Design Name: 
// Module Name: clp_2
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


// N : NUM_OF_CHAN

// ps : current state
// cs : next state --> localparam


module clp_2 #(parameter INT =8 ,  parameter TR =3 , parameter K=3 , parameter S=2 , parameter N=32 ,parameter M=64 ,parameter ADDR = 6)  
 (clk , rst , act_in, act_en_i, act_ready_o , wght_in , wght_en_i  , wght_ready_o, out_pe ,ack_reg );
//////////////////////////////////////////////////////////////

        localparam IDLE=0 , W_LOAD=1 , W_READ =2 , MUL= 3 , FLUSH= 4 ,MAC=5;


        input clk, rst;
        input[INT* N -1:0]    act_in; // bus 
        input signed[INT*N-1:0] wght_in;     
        input wght_en_i;
        input act_en_i;
        
        output act_ready_o;
        output wght_ready_o;
        output reg  [INT*2 + $clog2(K*K*N)-1:0 ]out_pe;
        
        output reg ack_reg;         
    
        reg act_en_reg;
        reg wght_en_reg;
        
        wire [INT*2 + $clog2(K*K*N)-1:0  ] relu_out ;

        reg [ADDR-1:0] wght_addr_reg;
        
        reg [ADDR-1:0] wght_w_addr_reg;
        
        reg [ADDR-1:0] wght_r_addr_reg;
        
        reg [ADDR-1:0] psum_w_addr_reg ; 
        reg [ADDR-1:0] psum_addr_reg;
    
        reg [INT-1:0] act_in_reg [0:N-1] ;
        
        reg signed [INT-1:0] wght_in_reg [0:N-1] ;
        reg signed [INT*2 + $clog2( K*K*N) -1:0] psum ; // 2n + log (CRS) bit
        reg signed [INT*2 + $clog2( K*K*N) -1:0] psum2 ; // 2n + log (CRS) bit

        wire signed [INT-1:0]  wght_in_wire [0:N-1];
        wire signed [INT*2-1:0]  inter_out [0:N-1];
        
        reg signed [INT*2 + $clog2(K*K*N) -1:0]sumreg[0:N-1];

        reg signed[INT*2 + $clog2( K*K*N) -1:0] sum[0:N-1] ;

        reg [3:0] ps , ns; 

        // status registers are needed  
        reg wght_load ;
        reg wght_read;
        reg wght_ready_reg ;
        
        reg wght_load_done;
        
        reg act_ready_reg;
        reg act_load;
        reg act_load_done ;
        
        wire [INT*2-1:0] outbuf_out;
        
        reg psum_out_en;

        wire psum_en[ 0:N-1];
        reg [4:0] psum_cnt;
        reg relu_sig ;
        reg signed [INT*2 + $clog2(N*K*K) -1:0]  psum_to_relu;
        
        reg toggle ;
        reg [INT-1:0 ] act_in_reg_q [0:N-1];

        reg psum_en_q;
        reg psum_en_qq;
        reg psum_en_qqq;
        reg psum_en_qqqq;
        reg mac_en ; 
        reg acc_en;
        reg psum_r_addr_reg;

//////////////////////////////////////////////////////////////
    always @ (*) begin
        if(wght_load) 
            wght_addr_reg = wght_w_addr_reg;
        else if( wght_read  )
            wght_addr_reg = wght_r_addr_reg;
        else begin
        
        wght_addr_reg   =wght_addr_reg;
        end 
        
    end

     
        always @ ( *  )  begin //  glitch not 
                act_in_reg [0] =   act_in[INT-1:0];
                act_in_reg [1] =   act_in[INT*2-1:INT];
                act_in_reg [2] =   act_in[INT*3-1:INT*2];
                act_in_reg [3] =   act_in[INT*4-1:INT*3];
                act_in_reg [4] =   act_in[INT*5-1:INT*4];
                act_in_reg [5] =   act_in[INT*6-1:INT*5];
                act_in_reg [6] =   act_in[INT*7-1:INT*6];
                act_in_reg [7] =   act_in[INT*8-1:INT*7];
                act_in_reg [8] =   act_in[INT*9-1:INT*8];
                act_in_reg [9] =   act_in[INT*10-1:INT*9];
                act_in_reg [10] =   act_in[INT*11-1:INT*10];
                act_in_reg [11] =   act_in[INT*12-1:INT*11];
                act_in_reg [12] =   act_in[INT*13-1:INT*12];
                act_in_reg [13] =   act_in[INT*14-1:INT*13];
                act_in_reg [14] =   act_in[INT*15-1:INT*14];
                act_in_reg [15] =   act_in[INT*16-1:INT*15];
                
                
                
                act_in_reg [16] =   act_in[INT*17-1: INT * 16];
                act_in_reg [17] =   act_in[INT*18-1:INT*17];
                act_in_reg [18] =   act_in[INT*19-1:INT*18];
                act_in_reg [19] =   act_in[INT*20-1:INT*19];
                act_in_reg [20] =   act_in[INT*21-1:INT*20];
                act_in_reg [21] =   act_in[INT*22-1:INT*21];
                act_in_reg [22] =   act_in[INT*23-1:INT*22];
                act_in_reg [23] =   act_in[INT*24-1:INT*23];
                act_in_reg [24] =   act_in[INT*25-1:INT*24];
                act_in_reg [25] =   act_in[INT*26-1:INT*25];
                act_in_reg [26] =   act_in[INT*27-1:INT*26];
                act_in_reg [27] =   act_in[INT*28-1:INT*27];
                act_in_reg [28] =   act_in[INT*29-1:INT*28];
                act_in_reg [29] =   act_in[INT*30-1:INT*29];
                act_in_reg [30] =   act_in[INT*31-1:INT*30];
                act_in_reg [31 ] =   act_in[INT*32-1:INT*31];
                
                act_en_reg     =   act_en_i; 
           end
    
    always @ (posedge clk) begin
        act_in_reg_q[0] <= act_in_reg[0];
        act_in_reg_q[1] <= act_in_reg[1];
        act_in_reg_q[2] <= act_in_reg[2];  
        act_in_reg_q[3] <= act_in_reg[3];
        act_in_reg_q[4] <= act_in_reg[4];
        act_in_reg_q[5] <= act_in_reg[5];
        act_in_reg_q[6] <= act_in_reg[6];
        act_in_reg_q[7] <= act_in_reg[7];
        act_in_reg_q[8] <= act_in_reg[8];
        act_in_reg_q[9] <= act_in_reg[9];
        act_in_reg_q[10] <= act_in_reg[10];
        act_in_reg_q[11] <= act_in_reg[11];
        act_in_reg_q[12] <= act_in_reg[12];
        act_in_reg_q[13] <= act_in_reg[13];
        act_in_reg_q[14] <= act_in_reg[14];
        act_in_reg_q[15] <= act_in_reg[15];

        act_in_reg_q[16] <= act_in_reg[16];
        act_in_reg_q[17] <= act_in_reg[17];
        act_in_reg_q[18] <= act_in_reg[18];  
        act_in_reg_q[19] <= act_in_reg[19];
        act_in_reg_q[20] <= act_in_reg[20];
        act_in_reg_q[21] <= act_in_reg[21];
        act_in_reg_q[22] <= act_in_reg[22];
        act_in_reg_q[23] <= act_in_reg[23];
        act_in_reg_q[24] <= act_in_reg[24];
        act_in_reg_q[25] <= act_in_reg[25];
        act_in_reg_q[26] <= act_in_reg[26];
        act_in_reg_q[27] <= act_in_reg[27];
        act_in_reg_q[28] <= act_in_reg[28];
        act_in_reg_q[29] <= act_in_reg[29];
        act_in_reg_q[30] <= act_in_reg[30];
        act_in_reg_q[31] <= act_in_reg[31];
    end
        
    
       
       
       always @ (*) begin
            wght_in_reg [0] =   wght_in[INT-1:0];
            wght_in_reg [1] =   wght_in[INT*2-1:INT];
            wght_in_reg [2] =   wght_in[INT*3-1:INT*2];
            wght_in_reg [3] =   wght_in[INT*4-1:INT*3];
            wght_in_reg [4] =   wght_in[INT*5-1:INT*4];
            wght_in_reg [5] =   wght_in[INT*6-1:INT*5];
            wght_in_reg [6] =   wght_in[INT*7-1:INT*6];
            wght_in_reg [7] =   wght_in[INT*8-1:INT*7];
            wght_in_reg [8] =   wght_in[INT*9-1:INT*8];
            wght_in_reg [9] =   wght_in[INT*10-1:INT*9];
            wght_in_reg [10] =   wght_in[INT*11-1:INT*10];
            wght_in_reg [11] =   wght_in[INT*12-1:INT*11];
            wght_in_reg [12] =   wght_in[INT*13-1:INT*12];
            wght_in_reg [13] =   wght_in[INT*14-1:INT*13];
            wght_in_reg [14] =   wght_in[INT*15-1:INT*14];
            wght_in_reg [15] =   wght_in[INT*16-1:INT*15];
            
            wght_in_reg [16] =   wght_in[INT*17-1: INT * 16];
            wght_in_reg [17] =   wght_in[INT*18-1:INT*17];
            wght_in_reg [18] =   wght_in[INT*19-1:INT*18];
            wght_in_reg [19] =   wght_in[INT*20-1:INT*19];
            wght_in_reg [20] =   wght_in[INT*21-1:INT*20];
            wght_in_reg [21] =   wght_in[INT*22-1:INT*21];
            wght_in_reg [22] =   wght_in[INT*23-1:INT*22];
            wght_in_reg [23] =   wght_in[INT*24-1:INT*23];
            wght_in_reg [24] =   wght_in[INT*25-1:INT*24];
            wght_in_reg [25] =   wght_in[INT*26-1:INT*25];
            wght_in_reg [26] =   wght_in[INT*27-1:INT*26];
            wght_in_reg [27] =   wght_in[INT*28-1:INT*27];
            wght_in_reg [28] =   wght_in[INT*29-1:INT*28];
            wght_in_reg [29] =   wght_in[INT*30-1:INT*29];
            wght_in_reg [30] =   wght_in[INT*31-1:INT*30];
            wght_in_reg [31 ] =   wght_in[INT*32-1:INT*31];
            wght_en_reg = wght_en_i;
        end
        
        
        
        
        generate
        genvar i;
         for ( i=0; i<N ; i=i+1) begin 
            wght_BRAM  # (.INT(INT) ,  . ADDR(4)) weight_A   ( .clk(clk) , .we(wght_en_reg) ,. addr(wght_addr_reg) ,. din(wght_in_reg[i]) ,.dout (wght_in_wire[i] ) );
            MAC_UNIT     #(.INT(INT) )   mac(.in1(act_in_reg_q[i]), .en(mac_en), .in2(wght_in_wire[i]), .clk(clk), .rst(rst) , .out_mac(inter_out[i]) ,. out_en(psum_en[i] ));
        end
        endgenerate

        //nest stage transition 
        always @ ( posedge clk ) begin
        if(rst ) begin
            ps <= IDLE; end
         else begin
            ps<=ns; end
        end
    always @ (*) begin
    case(ps)
    IDLE: begin 
             psum_cnt=0;
             mac_en=0;
             relu_sig=0;
             wght_ready_reg =1; // ready  to  dram
             psum =0;
             psum2=0;
             wght_r_addr_reg =0; //iniit 
             wght_w_addr_reg=0;
             toggle=0 ;
             psum_w_addr_reg=0;
             sumreg[0]=0;
             sumreg[1]=0;
             sumreg[2]=0;
             sumreg[3]=0;
             sumreg[4]=0;
             sumreg[5]=0;
             sumreg[6]=0;
             sumreg[7]=0;
             
             
             act_ready_reg=0;
             
             if(wght_en_i==1)begin 
                 ns=W_LOAD;
                 wght_load=1;
             end else  begin
                    ns= IDLE; end
          end  
    W_LOAD:  begin 
               // wght_load=1 ; 
                if(wght_en_i == 0)  begin
                    //act_ready_reg  = 1;
                    wght_load=0; // DRAM --> BRAM
                    ns <= W_READ ; end // load in wght mem
                 else begin
                       ns <= W_LOAD ;
                     //  act_ready_reg=0;
                       wght_load = 1;
                       end
            end  
    W_READ :  begin   
                if(act_en_i)  begin 
                    wght_read = 1 ; // BRAM --> MAC Unit (reg file)
                    mac_en=1;
                      
                end else begin  wght_read= 0 ;
                            ns<=W_READ; 
                            mac_en = 0 ;end  
                 end    
   
    endcase 
    end

    always @ (*) begin
    
    if(wght_w_addr_reg > 8) begin
        act_ready_reg=1;
    end else begin
    act_ready_reg=0;
    end
    
    
    end
    always @ (posedge clk  ) 
    begin
            if( wght_load  ) begin // is_wght_BRAM_write_
                wght_w_addr_reg<=wght_w_addr_reg+1;  
            end 
            else if(wght_read ) begin  
             
                if(wght_r_addr_reg >= K*K-1) begin 
                     wght_r_addr_reg<=0; 
               end else begin    wght_r_addr_reg<= wght_r_addr_reg+1; end 
           end else  begin 
           
           wght_r_addr_reg<= wght_r_addr_reg; 
           
           end
    end
    assign wght_ready_o = wght_ready_reg; 
    assign act_ready_o = act_ready_reg; 
   always @ ( posedge clk ) begin // adder tree 3ch annel 
            sumreg[0] <=  sum[0];
            sumreg[1]  <=  sum[1] ;
            sumreg[2]  <=  sum[2] ;
            sumreg[3]  <=  sum[3] ;
            sumreg[4]  <=  sum[4] ;
            sumreg[5]  <=  sum[5] ;
            sumreg[6]  <=  sum[6] ;
            sumreg[7]  <=  sum[7] ;
            sumreg[8]  <=  sum[8] ;
            sumreg[9]  <=  sum[9] ;
            sumreg[10]  <=  sum[10] ;
            sumreg[11]  <=  sum[11] ;
            sumreg[12]  <=  sum[12] ;
            sumreg[13]  <=  sum[13] ;
            sumreg[14]  <=  sum[14] ;
            sumreg[15]  <=  sum[15] ;
            
            
             
            sumreg[16] = sum[16];
            sumreg[17] =sum[17];
            sumreg[18] =sum[18];
            sumreg[19] =sum[19];
            sumreg[20] =sum[20];
            sumreg[21] =sum[21];
            sumreg[22] =sum[22];
            sumreg[23] =sum[23];
            
            
            sumreg[24] =sum[24];
            sumreg[25] =sum[25];
            sumreg[26] =sum[26];
            sumreg[27] =sum[27];
            
            sumreg[28] =sum[28];
            sumreg[29] =sum[29];
            
            
 
    
   end
   
   // double buffer 나중에  .;............. size == Tr * Tc 
   
   always @ (*) begin
            out_pe = relu_out;
            sum[0] = inter_out[0] + inter_out[1];
            sum[1] = inter_out[2] + inter_out[3];
            sum[2] = inter_out[4] + inter_out[5];
            sum[3] = inter_out[6] + inter_out[7];
            sum[4] = inter_out[8] + inter_out[9];
            sum[5] = inter_out[10] + inter_out[11];
            sum[6] = inter_out[12] + inter_out[13];
            sum[7] = inter_out[14] + inter_out[15];
            sum[8] = inter_out[16] + inter_out[17];
            sum[9] = inter_out[18] + inter_out[19];
            sum[10] = inter_out[20] + inter_out[21];
            sum[11] = inter_out[22] + inter_out[23];
            sum[12] = inter_out[24] + inter_out[25];
            sum[13] = inter_out[26] + inter_out[27];
            sum[14] = inter_out[28] + inter_out[29];
            sum[15] = inter_out[30] + inter_out[31];
            
            
            
            
            
            
            sum[16] =sumreg[0] + sumreg[1];
            sum[17] =sumreg[2] + sumreg[3];
            sum[18] =sumreg[4] + sumreg[5];
            sum[19] =sumreg[6] + sumreg[7];
            sum[20] =sumreg[8] + sumreg[9];
            sum[21] =sumreg[10] + sumreg[11];
            sum[22] =sumreg[12] + sumreg[13];
            sum[23] =sumreg[14] + sumreg[15];
            
            
            
            
            sum[24] =sumreg[16] + sumreg[17];
            sum[25] =sumreg[18] + sumreg[19];
            sum[26] =sumreg[20] + sumreg[21];
            sum[27] =sumreg[22] + sumreg[23];
            
            

            sum[28] = sumreg[24] + sumreg[25];
            sum[29] = sumreg[26] + sumreg[27];
            
            sum[30] = sumreg[28] + sumreg[29];

            
        end
   always @(*) begin
         acc_en = psum_en[0] && psum_en[1] &&  psum_en[2] && psum_en[3] &&  psum_en[4] && psum_en[5] &&  psum_en[6] && psum_en[7] &&  psum_en[8] && psum_en[9] &&  psum_en[10] 
         &&  psum_en[11]&&  psum_en[12]&&  psum_en[13]&&  psum_en[14]&&  psum_en[15];
   end

  always @ (posedge clk ) begin
      if(psum_cnt ==K*K-1)  begin
            relu_sig <=1; 
            psum_cnt <=0;
            ack_reg<=1; 
      end
  else begin
      relu_sig<=0;              
      ack_reg <= 0;
     if(psum_en_qqq) begin
          psum_cnt <= psum_cnt +1 ;
     end else begin 
     psum_cnt<=psum_cnt;
     end
     
  end
  end
  
  
   //output buffer
   always @ (posedge clk ) begin
       psum_en_q <= acc_en;
       psum_en_qq <= psum_en_q;
       psum_en_qqq<= psum_en_qq;
       psum_en_qqqq<=psum_en_qqq;
       if(psum_en_qqqq) begin
           if(toggle)  begin
                psum2 <=   psum2 + sum[30];
                psum <= 0 ; 
                 end 
           else  begin
                psum <= psum + sum[30] ;
                psum2 <= 0 ;
                end 
       end 
   end   
   always @ (*) begin 
   if(psum_out_en)  begin
        psum_addr_reg = psum_w_addr_reg ;end
        else begin 
        psum_addr_reg = psum_r_addr_reg; 
        end
        
        
   end 
   
   
   always @ (posedge clk) begin
   
   if (psum_out_en) begin 
    if(psum_w_addr_reg == TR*TR -1) begin  // output size = 7 x 7
            psum_w_addr_reg<=0;
    end else begin
     psum_w_addr_reg<= psum_w_addr_reg +1; 
    end
    end
    
   
   end

   
   always @(*) begin   
       if(relu_sig==1) begin
            psum_out_en =1; 
           if(toggle) begin 
              psum_to_relu = psum2;
              toggle = ~toggle ;
           end  else begin 
              psum_to_relu = psum ;
               toggle = ~toggle ;
              end 
       end else begin
              psum_out_en = 0  ;         
       end
   end
       RELU #(.BIT(INT*2 + $clog2(K*K*N) ))relu_m ( .din(psum_to_relu) , .dout(relu_out) ) ; 
       
       out_BRAM  #( .INT( INT*2 + $clog2(K*K*N)  )  ,. ADDR(6) )  OUT_A (.clk(clk) , .we(psum_out_en), .addr(psum_addr_reg)  ,  .din(relu_out) , .dout(outbuf_out) ); //double buffer 
       out_BRAM  #( .INT( INT*2 + $clog2(K*K*N)  )  ,. ADDR(6) )  OUT_B (.clk(clk) , .we(psum_out_en), .addr(psum_addr_reg)  ,  .din(relu_out) , .dout(outbuf_out) ); //double buffer 
       
endmodule	    

