`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2019 09:39:08 AM
// Design Name: 
// Module Name: rd_axi_ctr
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
module rddr_axi_ctr# (
	parameter ADDR_WIDTH  = 64         , //address bitwidth
	parameter DATA_WIDTH  = 32 	     //data bitwidth, the real value is DATA_WIDTH = 64
	)(
    //system
    input  wire                      clk_sys             ,
    input  wire                      rst_sys             ,
    //start 
    input  wire                      rd_yuv_start        ,
    input  wire [ADDR_WIDTH - 1 : 0] rd_yuv_addr         ,

    //write fifo
    output reg [31:0]               rd_yuv_data         ,    	
    output wire                      rd_yuv_data_vld     ,	
    //AXI-MM read interface
    output reg  [ADDR_WIDTH - 1 : 0] m_axi_araddr        ,
    output wire [  7: 0]             m_axi_arlen         ,   // m_axi_arlen = 8'd255
    output wire [  2: 0]             m_axi_arsize        ,   // m_axi_arsize = 3'd3
    output wire [  1: 0]             m_axi_arburst       ,   // m_axi_arburst = 2'd1
    output wire                      m_axi_arlock        ,   // m_axi_arlock = 1'b0
    output wire [  3: 0]             m_axi_arcache       ,   // m_axi_arcache = 4'd3
    output wire [  2: 0]             m_axi_arprot        ,   // m_axi_arprot = 3'd0
    output wire [  3: 0]             m_axi_arqos         ,   // m_axi_arqos = 4'd0
    output reg                       m_axi_arvalid       ,
    input  wire                      m_axi_arready       ,
    input  wire [DATA_WIDTH - 1 : 0] m_axi_rdata         ,
    input  wire [  1: 0]             m_axi_rresp         ,
    input  wire                      m_axi_rlast         ,
    input  wire                      m_axi_rvalid        ,
    output wire                      m_axi_rready        
);
//=============================paramer define============================= 

//=============================signal define============================= 
reg [3:0]rd_yuv_start_dly;
wire     rd_start_posedge;
//=============================module instance============================
 
//===================================================================
  assign m_axi_arsize    = 3'd2                        ;//16 byte
  assign m_axi_arburst   = 2'd1                        ;
  assign m_axi_arlock    = 1'b0                        ;
  assign m_axi_arcache   = 4'd3                        ;
  assign m_axi_arprot    = 3'd0                        ;
  assign m_axi_arqos     = 4'd0                        ;
  assign m_axi_arlen     = 8'h1; //16          
  assign m_axi_rready    = 1'b1;
//  assign rd_yuv_data     = m_axi_rdata;
  assign rd_yuv_data_vld = m_axi_rvalid & (m_axi_rlast==1'b0); 
//==================================================================
// axi control 
//==================================================================
  always @ (posedge clk_sys or posedge rst_sys) 
  begin
     if (rst_sys == 1'b1)begin
         rd_yuv_start_dly <=  0 ;
     end
     else begin
         rd_yuv_start_dly <=  {rd_yuv_start_dly[2:0],rd_yuv_start} ;
     end
  end 

assign rd_start_posedge = rd_yuv_start & (!rd_yuv_start_dly[0]);

always @ (posedge clk_sys or posedge rst_sys) begin
    if (rst_sys == 1'b1)begin
         m_axi_arvalid <=  1'b0 ;
	end else begin
		if(rd_start_posedge )begin
			m_axi_arvalid <=  1'b1 ;
		end else if(m_axi_arready & m_axi_arvalid) begin
			m_axi_arvalid <=  1'b0 ;	
		end 
	end
end  

always @ (posedge clk_sys or posedge rst_sys) 
begin
    if (rst_sys == 1'b1)begin
        m_axi_araddr <=  0 ;
	end	else if(rd_start_posedge) begin
		m_axi_araddr <=  rd_yuv_addr ;
	end 
end 

always @ (*) 
begin
    if (rst_sys == 1'b1)begin
        rd_yuv_data <=  0 ;
	end	else if(rd_yuv_data_vld) begin
		rd_yuv_data <=  m_axi_rdata ;
	end 
end 
endmodule




