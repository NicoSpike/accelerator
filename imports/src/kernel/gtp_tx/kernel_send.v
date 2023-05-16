`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/13/2020 09:39:08 AM
// Design Name: 
// Module Name: kernel_send
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
module kernel_send(
  // System Signals
  input  wire                                    ap_clk               ,
  input  wire                                    ap_rst               ,

  input  wire                                    tx_clk               ,
  output wire [31:0]                             gtp_txdata           ,
  output wire [ 3:0]                             gtp_txctl            ,   
  //frome other interface
  input  wire                                    sfp_wr_en            ,
  input  wire [64-1:0]                           sfp_wr_data          ,
  // board comm
  input wire                                     next_buff_vaild      ,
  input wire  [31:0]                             next_buff_statue     ,
  //send the rx qune statue to contralateral 
  input wire                                     send_buff_vaild      ,
  input wire  [31:0]                             send_buff_statue     , 
  output wire                                    send_statue          ,
  
  input wire                                     send_back_flag,
  input wire  [15:0]                             send_back_data,  
  input wire                                     send_info_vaild,
  input wire  [15:0]                             send_info   
               
);
//=============================paramer define============================= 


//=============================signal define=============================
wire                tx_allow;
wire [63:0]         tx_rddata;
wire                tx_rden;
reg                 send_idle_lock;
reg [63:0]          send_data_lock;
reg                 send_buff_vaild_flag;
reg [3:0]           send_buff_vaild_cnt; 
reg                 send_buff_flag;  
reg [1:0]           send_buff_dly;   
wire                send_flag_posedge;  
//=============================module instance============================
    send_buf send_buf(
    .ap_clk              (ap_clk),
    .ap_rst              (ap_rst),
    .tx_clk              (tx_clk),

    .sfp_wr_en           (sfp_wr_en),
    .sfp_wr_data         (sfp_wr_data),

    .next_buff_vaild     (next_buff_vaild),
    .next_buff_statue    (next_buff_statue),
    
    .tx_allow            (tx_allow),
    .tx_rden             (tx_rden),  
    .tx_rddata           (tx_rddata),  

    .send_idle           (send_statue) 
        
  );
//=============================module instance============================
    send_frame send_frame(
    .ap_rst              (ap_rst),
    .tx_clk              (tx_clk),

    .send_buff_vaild     (send_flag_posedge),
    .send_buff_statue    (send_buff_statue), 
    
    .tx_allow            (tx_allow),
    .tx_rden             (tx_rden),
    .tx_rddata           (tx_rddata),  
                                      
    .gtp_txdata          (gtp_txdata), 
    .gtp_txctl           (gtp_txctl),
    
    .send_back_flag	    (send_back_flag),	
    .send_back_data	    (send_back_data),	  
    .send_info_vaild	(send_info_vaild),	
    .send_info		    (send_info)	  
  );
  
always @ (posedge ap_clk )begin
  if (ap_rst == 1'b1)begin
      send_buff_vaild_flag <=  1'b0 ;
  end else begin
      if(send_buff_vaild_cnt==4'hF)begin
        send_buff_vaild_flag <=  1'b0 ;
      end else if(send_buff_vaild==1'b1)begin
        send_buff_vaild_flag <=  1'b1 ;
      end        
  end
end 

always @ (posedge ap_clk )begin
  if (ap_rst == 1'b1)begin
      send_buff_vaild_cnt <=  0 ;
  end else begin
      if(send_buff_vaild_cnt>=4'h1)begin
        send_buff_vaild_cnt <=  send_buff_vaild_cnt+1'b1 ;
      end else if(send_buff_vaild==1'b1)begin
        send_buff_vaild_cnt <=  4'h1 ;
      end        
  end
end 


always @ (posedge tx_clk )begin
  if (ap_rst == 1'b1)begin
      send_buff_flag <=  1'b0 ;
  end else begin
      if(send_buff_vaild_cnt>=4'h1)begin
        send_buff_flag <=  1'b1 ;
      end else begin
        send_buff_flag <=  1'b0 ;
      end        
  end
end 

always @ (posedge tx_clk )begin
  if (ap_rst == 1'b1)begin
      send_buff_dly <=  2'b0 ;
  end else begin
      send_buff_dly <=  {send_buff_dly[0],send_buff_flag} ;      
  end
end 

assign send_flag_posedge = send_buff_dly[0] & (~send_buff_dly[1]);  
endmodule
