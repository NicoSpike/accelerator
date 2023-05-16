`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/13/2020 09:39:08 AM
// Design Name: 
// Module Name: kernel_rece
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
module kernel_rece(
  // System Signals
  input wire                                     ap_clk               ,
  input wire                                     ap_rst               ,

  input  wire                                    rx_clk               ,
  input  wire [31:0]                             gtp_rxdata           ,
  input  wire [ 3:0]                             gtp_rxctl            ,

  // board comm
  output wire                                    next_buff_vaild      ,
  output wire  [31:0]                            next_buff_statue     ,

  output wire                                    send_buff_vaild      ,
  output wire  [31:0]                            send_buff_statue     ,
  //send to other interface
  input   wire                                   send_start           ,  
  // output  wire                                   sfp_rd_en            ,
  output  wire [64-1:0]                          sfp_rd_data          ,
  //read send statue
  output wire                                    rece_qune, 
             
  output wire                                     send_back_flag,
  output wire  [15:0]                             send_back_data,  
  output wire                                     send_info_vaild,
  output wire  [15:0]                             send_info                 
);
//=============================paramer define============================= 

//=============================signal define=============================
  wire                                      rx_wrram_en;
  wire  [15:0]                              rx_wrram_addr;
  wire  [63:0]                              rx_wrram_data;
  wire                                      rx_end       ;    
//=============================module instance============================
  rece_frame rece_frame(
  .ap_rst           (ap_rst),
  .rx_clk           (rx_clk),

  .gtp_rxdata       (gtp_rxdata),
  .gtp_rxctl        (gtp_rxctl),


  .rx_wrram_en      (rx_wrram_en),
  .rx_wrram_addr    (rx_wrram_addr),
  .rx_wrram_data    (rx_wrram_data), 

  .next_buff_vaild  (next_buff_vaild),
  .next_buff_statue (next_buff_statue),
  
  .send_back_flag	(send_back_flag),	
  .send_back_data	(send_back_data),	  
  .send_info_vaild	(send_info_vaild),	
  .send_info		(send_info)	 	 
  ); 
 
  rece_buf rece_buf(
  // System Signals
  .ap_clk           (ap_clk),
  .ap_rst           (ap_rst),
  .rx_clk           (rx_clk),
  
  .rx_wrram_en      (rx_wrram_en),
//  .rx_start_addr    (rx_start_addr),
  .rx_wrram_addr    (rx_wrram_addr),
  .rx_wrram_data    (rx_wrram_data),

  .send_buff_vaild  (send_buff_vaild),
  .send_buff_statue (send_buff_statue),

  .send_start       (send_start),
  // .sfp_rd_en        (sfp_rd_en),
  .sfp_rd_data      (sfp_rd_data),

  
  .rece_qune        (rece_qune)
//  .rece_qune_data   (rece_qune_data)     
  );
endmodule
