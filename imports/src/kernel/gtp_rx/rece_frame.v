`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/13/2020 09:39:08 AM
// Design Name: 
// Module Name: rece_frame
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
/*----------------------------------------------------------------------------
|   k285
|   NUM+LENGTH(BYTE)
|   data vaild
|
|   chesum
|   cccc3333 
|   length = datavaild+chesum+cccc3333
----------------------------------------------------------------------------*/
// page HEDA k285
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module rece_frame(
  // System Signals
  input                                      ap_rst,
  input                                      rx_clk,

  //frome gtp
  input    [31:0]                            gtp_rxdata,
  input    [ 3:0]                            gtp_rxctl,

  output reg                                 rx_wrram_en,
  output reg  [15:0]                         rx_wrram_addr,
  output reg  [63:0]                         rx_wrram_data, 
  output wire                                next_buff_vaild,
  output wire [31:0]                         next_buff_statue,
  
  output reg                                 send_back_flag,
  output reg  [15:0]                         send_back_data,  
  output wire                                send_info_vaild,
  output reg  [15:0]                         send_info   
);
//=============================paramer define============================= 
parameter state_idle           =4'd0;
parameter state_start           =4'd1;
parameter state_send            =4'd2;
parameter state_wait           =4'd3;
parameter state_done           =4'd4;
//=============================signal define=============================
(*mark_debug = "true"*)reg [ 3:0]      gtp_rxctl_reg;
(*mark_debug = "true"*)reg [31:0]      gtp_rxdata_reg;
(*mark_debug = "true"*)reg [ 3:0]      align_txctl;
(*mark_debug = "true"*)reg [ 3:0]      rece_rxctl;
(*mark_debug = "true"*)reg [31:0]      rece_rxdata;

reg             rece_head;
(*mark_debug = "true"*)reg [63:0]      rece_data_buf;
(*mark_debug = "true"*)reg [ 3:0]      rece_rxctl_dly;

 reg  [63:0]                           rx_wrram_data_dly; 
//=============================module instance============================
always @ (posedge rx_clk )begin
  if (ap_rst == 1'b1)begin
      align_txctl <=  0 ;
  end else begin
      if(gtp_rxctl!=4'b0000)begin
        align_txctl <=  gtp_rxctl ;
      end 
  end
end 
always @ (posedge rx_clk )begin
  if (ap_rst == 1'b1)begin
      gtp_rxctl_reg <=  0 ;
  end else begin
      gtp_rxctl_reg <=  gtp_rxctl ;
  end
end 

always @ (posedge rx_clk )begin
  if (ap_rst == 1'b1)begin
      gtp_rxdata_reg <=  0 ;
  end else begin
      gtp_rxdata_reg <=  gtp_rxdata ;
  end
end 

always @ (posedge rx_clk )begin
  if (ap_rst == 1'b1)begin
      rece_rxdata <=  0 ;
  end else begin
    if(align_txctl==4'b0001)begin
      rece_rxdata <=  gtp_rxdata_reg ;
    end else begin
      rece_rxdata <=  {gtp_rxdata[15:0],gtp_rxdata_reg[31:16]} ;
    end       
  end
end 


always @ (posedge rx_clk )begin
  if (ap_rst == 1'b1)begin
      rece_rxctl <=  0 ;
  end else begin
    if(align_txctl==4'b0001)begin
      rece_rxctl <=  gtp_rxctl_reg ;
    end else begin
      rece_rxctl <=  {gtp_rxctl[1:0],gtp_rxctl_reg[3:2]} ;
    end       
  end
end 


always @ (posedge rx_clk )begin
  if (ap_rst == 1'b1)begin
      rece_rxctl_dly <=  0 ;
  end else begin
      rece_rxctl_dly <=  rece_rxctl ;      
  end
end 

always @ (posedge rx_clk )begin
  if (ap_rst == 1'b1)begin
      rece_data_buf <=  0 ;
  end else begin
      rece_data_buf <=  {rece_rxdata,rece_data_buf[63:32]} ;      
  end
end 

//parsing page info
reg recev_info_flag;
reg [7:0]rece_sum;
reg [7:0]rece_cnt;
(*mark_debug = "true"*)reg [7:0]rece_cnt_old;
reg      recev_en;
reg      recev_data_en;
reg      rece_succe;
//num sum 55bc
always @ (posedge rx_clk )begin
  if (ap_rst == 1'b1)begin
      recev_info_flag <=  1'b0 ;
  end else begin
    if((rece_rxctl_dly==4'b0001)&&(rece_data_buf[47:32]==16'h55bc))begin
      recev_info_flag <=  1'b1 ;
    end else begin
      recev_info_flag <=  1'b0 ;        
    end       
  end
end 

always @ (posedge rx_clk )begin
  if (ap_rst == 1'b1)begin
      rece_cnt <=  8'h0 ;
  end else begin
    if(recev_info_flag==1'b1)begin
      rece_cnt <=rece_data_buf[31:24] ;   
    end       
  end
end 

always @ (posedge rx_clk )begin
  if (ap_rst == 1'b1)begin
      rece_cnt_old <=  8'h0 ;
  end else if(rx_wrram_en==1'b1) begin
      rece_cnt_old <=rece_cnt ;         
  end
end 


always @ (posedge rx_clk )begin
  if (ap_rst == 1'b1)begin
      rece_sum <=  8'h0 ;
  end else begin
    if(recev_info_flag==1'b1)begin
      rece_sum <=rece_data_buf[55:48]+rece_data_buf[39:32] ;   
    end       
  end
end 

always @ (posedge rx_clk )begin
  if (ap_rst == 1'b1)begin
      recev_en <=  1'b0 ;
  end else begin
      recev_en <=  recev_info_flag ;
  end
end 
reg       recev_data_en_syn1;
reg       recev_data_en_syn2;
always @ (posedge rx_clk )begin
  if (ap_rst == 1'b1)begin
      recev_data_en_syn2 <=  1'b0 ;      
  end else begin
      recev_data_en_syn2 <= recev_en ;       
  end
end 
//write data
always @ (posedge rx_clk )begin
  if (ap_rst == 1'b1)begin
      rx_wrram_en <=  1'b0 ;
  end else begin
    if((recev_en==1'b1)&&(rece_sum==rx_wrram_data_dly[23:16])&&(rece_cnt==rece_cnt_old+1'b1))begin
      rx_wrram_en <=  1'b1 ;
    end else begin
      rx_wrram_en <=  1'b0 ;        
    end       
  end
end 


always @ (posedge rx_clk )begin
  if (ap_rst == 1'b1)begin
      rx_wrram_data_dly <=  0 ;
      rx_wrram_data <=  0 ;
  end else begin
      rx_wrram_data_dly <=  rece_data_buf ;
      rx_wrram_data <=  rx_wrram_data_dly ;          
  end
end 

always @ (posedge rx_clk )begin
  if (ap_rst == 1'b1)begin
      rx_wrram_addr <=  0 ;
  end else begin
    if(rx_wrram_en==1'b1)begin
      rx_wrram_addr <=  rx_wrram_addr+1'b1 ;     
    end       
  end
end 

//write data
always @ (posedge rx_clk )begin
  if (ap_rst == 1'b1)begin
      rece_succe <=  1'b0 ;
  end else begin
    if((recev_en==1'b1)&&(rece_sum==rx_wrram_data_dly[23:16]))begin
      rece_succe <=  1'b1 ;
    end else begin
      rece_succe <=  1'b0 ;        
    end       
  end
end 


always @ (posedge rx_clk )begin
  if (ap_rst == 1'b1)begin
      send_back_data <=0; 
  end else if(recev_data_en_syn2==1'b1) begin
      send_back_data <={rece_cnt,rx_wrram_en,rece_succe,6'h0};      
  end
end 

always @ (posedge rx_clk )begin
  if (ap_rst == 1'b1)begin
      send_back_flag <=1'b0; 
  end else if(recev_data_en_syn2==1'b1) begin
      send_back_flag <=1'b1;      
  end else begin
      send_back_flag <=1'b0;
  end     
end 
//next level receive statue
//num sum aabc pace_num num  flagrx_wrram_en flagsucce ,flagempty 
reg      next_buff_vaild1_reg;
reg [31:0]next_buff_statue1_reg;
reg [2:0] next_buff_vaild2_reg;
reg [31:0]next_buff_statue2_reg;
reg [7:0] pack_sum;
reg [7:0] pack_cnt;
reg [7:0] pack_cnt_old;
reg       next_pack_vaild;
reg       next_pack_vaild1;
always @ (posedge rx_clk )begin
  if (ap_rst == 1'b1)begin
      next_pack_vaild <=  1'b0 ;
  end else begin
    if((rece_rxctl_dly==4'b0001)&&(rece_data_buf[47:32]==16'haabc))begin
      next_pack_vaild <= 1'b1;      
    end else begin
      next_pack_vaild <= 1'b0;           
    end       
  end
end 

always @ (posedge rx_clk )begin
  if (ap_rst == 1'b1)begin
      next_buff_statue1_reg <= 1'b0 ;
  end else begin
      next_buff_statue1_reg <=rece_data_buf[31:0];        
  end
end 
//lock data
always @ (posedge rx_clk )begin
  if (ap_rst == 1'b1)begin
      pack_sum <=  8'h0 ;
  end else begin
    if(next_pack_vaild==1'b1)begin
      pack_sum <=rece_data_buf[55:48]+rece_data_buf[39:32] ;   
    end       
  end
end 

always @ (posedge rx_clk )begin
  if (ap_rst == 1'b1)begin
      pack_cnt <=  8'h0 ;
  end else begin
    if(next_pack_vaild==1'b1)begin
      pack_cnt <=rece_data_buf[31:24] ;   
    end       
  end
end 


always @ (posedge rx_clk )begin
  if (ap_rst == 1'b1)begin
      next_pack_vaild1 <= 1'b0 ;
  end else begin
      next_pack_vaild1 <=next_pack_vaild;        
  end
end 


always @ (posedge rx_clk )begin
  if (ap_rst == 1'b1)begin
      pack_cnt_old <=  8'h0 ;
  end else begin
    if(next_buff_vaild1_reg==1'b1)begin
      pack_cnt_old <=pack_cnt ;   
    end       
  end
end 

always @ (posedge rx_clk )begin
  if (ap_rst == 1'b1)begin
      next_buff_vaild1_reg <=  1'b0 ;
  end else begin
    if((next_pack_vaild1==1'b1)&&(pack_sum==next_buff_statue1_reg[23:16])&&(pack_cnt==pack_cnt_old+1'b1))begin
      next_buff_vaild1_reg <=  1'b1 ;
    end else begin
      next_buff_vaild1_reg <=  1'b0 ;        
    end       
  end
end 


always @ (posedge rx_clk )begin
  if (ap_rst == 1'b1)begin
      next_buff_vaild2_reg <=  2'b0 ;     
  end else begin
      next_buff_vaild2_reg  <= {next_buff_vaild2_reg[1:0],next_buff_vaild1_reg} ;     
  end
end 

always @ (posedge rx_clk )begin
  if (ap_rst == 1'b1)begin
      next_buff_statue2_reg <=  0 ;      
  end else if(next_buff_vaild1_reg==1'b1) begin
      next_buff_statue2_reg <= next_buff_statue1_reg ;         
  end
end 

always @ (posedge rx_clk )begin
  if (ap_rst == 1'b1)begin
      send_info <=  0 ;      
  end else if(next_buff_vaild1_reg==1'b1) begin
      send_info <= next_buff_statue1_reg[15:0] ;         
  end
end 
assign next_buff_vaild =next_buff_vaild2_reg[0]|next_buff_vaild2_reg[1]|next_buff_vaild2_reg[2];
assign next_buff_statue=next_buff_statue2_reg[31:16];
assign send_info_vaild  = next_buff_vaild & send_info[0];
//test
reg rece_rxctl_test;

always @ (posedge rx_clk )begin
  if (ap_rst == 1'b1)begin
      rece_rxctl_test <=  0 ;      
  end else  begin
      rece_rxctl_test <=  rece_rxctl_dly;         
  end
end 

//ila_rx ila_rx(
//.clk 	    (rx_clk),
//.probe0    (align_txctl),
//.probe1    (rx_wrram_en),
//.probe2  (rece_data_buf),
//.probe3  (rece_rxctl_test)
//);


//ila_gtx ila_gtx(
//.clk 	    (rx_clk),
//.probe0    (align_txctl),
//.probe1    (gtp_rxdata),
//.probe2  (gtp_rxctl_reg),
//.probe3  (rece_rxctl),
//.probe4  (rece_data_buf)
//);

//(*mark_debug = "true"*)reg rece_flag;
(*mark_debug = "true"*)reg [31:0] receive_cnt;
  
always @ (posedge rx_clk )begin
  if (ap_rst == 1'b1)begin
    receive_cnt <=  0 ;
  end else if(rx_wrram_en)begin
    receive_cnt <=  receive_cnt+1'b1 ;
  end
end  

//always @ (posedge rx_clk )begin
//  if (ap_rst == 1'b1)begin
//    rece_flag <=  1'b0 ;
//  end else if(rece_rxctl_dly==1'b1)begin
//     if((rece_data_buf[63:48]==32'haa55)||(rece_data_buf[63:48]==32'h55aa))begin
//        rece_flag <=  1'b0 ;
//    end else begin
//        rece_flag <=  1'b1 ;
//    end 
//  end   
//end  
(*mark_debug = "true"*)reg rece_data_err;
//always @ (posedge rx_clk )begin
//  if (ap_rst == 1'b1)begin
//    rece_data_err <=  1'b0;
//  end else if(rx_wrram_en)begin
//      if((rx_wrram_data[63:32]==64'h00000001)&(rx_wrram_data[15:0]==16'h55aa))begin
//            rece_data_err <= 1'b0 ;
//       end else begin
//            rece_data_err <=  1'b1;
//       end     
//  end
//end  

always @ (posedge rx_clk )begin
  if (ap_rst == 1'b1)begin
    rece_data_err <=  1'b0;
  end else if((recev_en==1'b1)&&(rece_sum==rx_wrram_data_dly[23:16]))begin
    if((rece_cnt==rece_cnt_old+1'b1)||(rece_cnt==rece_cnt_old))begin
            rece_data_err <= 1'b0 ;
       end else begin
            rece_data_err <=  1'b1;
       end     
  end
end 



endmodule
