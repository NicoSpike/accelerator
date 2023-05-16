`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/13/2020 09:39:08 AM
// Design Name: 
// Module Name: kernel_top
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
module kernel_top(
  // System Signals
  input  wire                                    ap_clk               ,
  input  wire                                    ap_rst               ,

  input  wire                                    tx_clk               ,
  output wire [31:0]                             gtp_txdata           ,
  output wire [ 3:0]                             gtp_txctl            ,


  input  wire                                    rx_clk               ,
  input  wire [31:0]                             gtp_rxdata           ,
  input  wire [ 3:0]                             gtp_rxctl            ,

  //send to other interface
  input   wire                                   send_start           ,  
  // output  wire                                   sfp_rd_en            ,
  output  wire [64-1:0]                          sfp_rd_data          ,

  //frome other interface
  input  wire                                    sfp_wr_en            ,
  input  wire [64-1:0]                           sfp_wr_data          , 
  //read send statue
  output wire 									                 rece_qune            ,
//  output wire [31:0]                             rece_qune_data       , 
                
  output wire                                    send_statue 
);
//=============================paramer define============================= 


//=============================signal define=============================
wire next_buff_vaild     ;
wire [31:0]next_buff_statue     ;

wire send_buff_vaild     ;
wire [31:0]send_buff_statue     ;

wire                                     send_back_flag;
wire  [15:0]                             send_back_data;  
wire                                     send_info_vaild;
wire  [15:0]                             send_info ;   
//=============================module instance============================

//===================================================================
// kernel_rece 
//===================================================================
kernel_rece kernel_rece (
  .ap_clk         ( ap_clk                ),
  .ap_rst         ( ap_rst                ),

  .rx_clk         ( rx_clk                ),
  .gtp_rxdata     ( gtp_rxdata            ),
  .gtp_rxctl      ( gtp_rxctl             ),

  .next_buff_vaild ( next_buff_vaild             ),
  .next_buff_statue( next_buff_statue             ),

  .send_buff_vaild ( send_buff_vaild             ),
  .send_buff_statue( send_buff_statue             ), 


  .send_start     ( send_start            ),
  // .sfp_rd_en      ( sfp_rd_en             ),
  .sfp_rd_data    ( sfp_rd_data           ),
//  .sfp_rd_last    ( sfp_rd_last           ),
  
  .rece_qune      ( rece_qune             ),
  .send_back_flag	(send_back_flag),	
  .send_back_data	(send_back_data),	  
  .send_info_vaild	(send_info_vaild),	
  .send_info		(send_info)	  
  );
//===================================================================
// kernel_send 
//===================================================================
kernel_send kernel_send (
	.ap_clk       	( ap_clk                ),
	.ap_rst       	( ap_rst                ),

  .tx_clk         ( tx_clk                ),
  .gtp_txdata     ( gtp_txdata            ),
  .gtp_txctl      ( gtp_txctl             ),

  .next_buff_vaild ( next_buff_vaild             ),
  .next_buff_statue( next_buff_statue             ),

  .send_buff_vaild ( send_buff_vaild             ),
  .send_buff_statue( send_buff_statue             ), 
   //sfp send
   .sfp_wr_en     ( sfp_wr_en             ),
   .sfp_wr_data   ( sfp_wr_data           ),
//   .sfp_wr_last   ( sfp_wr_last           ),
   .send_statue    ( send_statue           ),
   
   .send_back_flag	(send_back_flag),	
   .send_back_data	(send_back_data),	  
   .send_info_vaild	(send_info_vaild),	
   .send_info		(send_info)	        
	);
	
	
(*mark_debug = "true"*)reg [31:0] send_cnt;  
(*mark_debug = "true"*)reg [31:0] receive_cnt;  
  
 always @ (posedge ap_clk or posedge ap_rst) begin
  if (ap_rst == 1'b1)begin
    send_cnt <=  0 ;
  end else if(sfp_wr_en)begin
    send_cnt <=  send_cnt+1'b1 ;
  end
end   

 always @ (posedge ap_clk or posedge ap_rst) begin
  if (ap_rst == 1'b1)begin
    receive_cnt <=  0 ;
  end else if(send_start)begin
    receive_cnt <=  receive_cnt+1'b1 ;
  end
end  
 	
endmodule
