`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/13/2020 09:39:08 AM
// Design Name: 
// Module Name: send_buf
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
module send_buf(
  // System Signals
  input                                      ap_clk,
  input                                      ap_rst,
  input                                      tx_clk,
  //frome other interface
  input                                      sfp_wr_en,
  input   [64-1:0]                           sfp_wr_data,


  // board comm
  input                                      next_buff_vaild      ,
  input   [31:0]                             next_buff_statue     ,
  //to send_frame
  //frome tx_buf
  output    reg                              tx_allow,
  input                                      tx_rden,  
  output    [64-1:0]                         tx_rddata,  


  output                                     send_idle           
);
//=============================paramer define============================= 

wire [63:0]axi_wr_data;
wire axi_fifo_write;
wire  wr_ctl;
reg sfp_wr_en_dly;
reg [31:0]next_statue;
wire      axi_fifo_full;
wire      axi_fifo_empty;
reg       next_buff_vaild_dly1;
reg       next_buff_vaild_dly2;
wire      next_buff_vaild_posedge;
//=============================signal define=============================

//=============================module instance============================
ddr_queue  ddr_queue(
  .rst        (ap_rst),
  .wr_clk     (ap_clk),
  .rd_clk     (tx_clk),
  .din        (axi_wr_data),
  .wr_en      (axi_fifo_write),
  .rd_en      (tx_rden),
  .dout       (tx_rddata),
  .full       (),
  .almost_full(axi_fifo_full),
  .empty      (axi_fifo_empty)
);
//===================================================================
// write ddr data to fifo
//===================================================================
assign axi_fifo_write =sfp_wr_en;
assign axi_wr_data =sfp_wr_data;
assign send_idle= (axi_fifo_full==1'b1)?1'b0:1'b1;
//===================================================================
//determine the sending status
//===================================================================
always @ (posedge tx_clk )begin
  if (ap_rst == 1'b1)begin
      next_buff_vaild_dly1 <= 1'b0 ;
      next_buff_vaild_dly2 <= 1'b0 ;      
  end else begin
      next_buff_vaild_dly1 <= next_buff_vaild ;
      next_buff_vaild_dly2 <= next_buff_vaild_dly1 ;  
  end
end

assign next_buff_vaild_posedge= next_buff_vaild_dly1 & (~next_buff_vaild_dly2);

always @ (posedge tx_clk )begin
  if (ap_rst == 1'b1)begin
      next_statue <=  32'd1024 ;
  end else if(next_buff_vaild_posedge==1'b1) begin
      next_statue <=  next_buff_statue ;
  end else if(tx_rden==1'b1) begin
      next_statue <=  next_statue-1'b1 ;      
  end
end 

always @ (posedge tx_clk )begin
  if (ap_rst == 1'b1)begin
      tx_allow <=  1'b0 ;
  end else if((next_statue>=32'd10)&(axi_fifo_empty==1'b0))begin
      tx_allow <=  1'b1 ;
  end else begin
      tx_allow <=  1'b0 ;      
  end
end 
endmodule
