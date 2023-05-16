`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2019 09:39:08 AM
// Design Name: 
// Module Name: deyuv_top
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
module dispatch_top# (
  parameter integer C_M00_AXI_NUM_THREADS      = 1 ,
  parameter integer C_M00_AXI_ID_WIDTH         = 1 ,
  parameter integer C_M00_AXI_ADDR_WIDTH       = 64,
  parameter integer C_M00_AXI_DATA_WIDTH       = 32
  )(
  // System Signals
  input  wire                                    ap_clk ,
  input  wire                                    ap_rst ,
  input  wire                                    ddr_initdone ,

  //read send statue
  input wire [6:0]                               rece_qune            , 
  input wire [6:0]                               send_statue          , 
  //send to other interface
  output wire [6:0]                              send_start           ,  
  input  wire [448-1:0]                          sfp_rd_data          ,
  //frome other interface
  output wire [6:0]                              sfp_wr_en            ,
  output wire [448-1:0]                          sfp_wr_data          , 
//  // AXI4 master interface m00_axi
//  output wire[C_M00_AXI_ADDR_WIDTH-1:0] tddr_axi_araddr,
//  input  wire            tddr_axi_arready,  
//  output wire  [2:0]    tddr_axi_arsize,  
//  output wire  [1:0]    tddr_axi_arburst,
//  output wire  [3:0]     tddr_axi_arcache,
//  output wire[C_M00_AXI_ID_WIDTH-1:0]          tddr_axi_arid,
//  output wire  [7:0]     tddr_axi_arlen,
//  output wire  [0:0]     tddr_axi_arlock,
//  output wire  [2:0]     tddr_axi_arprot,
//  output wire  [3:0]     tddr_axi_arqos,
//  input  wire  [1:0]     tddr_axi_rresp,
//  input  wire[C_M00_AXI_DATA_WIDTH-1:0]        tddr_axi_rdata,
//  input  wire[C_M00_AXI_ID_WIDTH-1:0]tddr_axi_rid,
//  input  wire            tddr_axi_rlast,
//  input  wire            tddr_axi_rvalid, 
//  input  wire [0:0]        tddr_axi_bid,  
//  input  wire [1:0]        tddr_axi_bresp,
//  input  wire             tddr_axi_bvalid,
//  output wire[C_M00_AXI_ADDR_WIDTH-1:0]tddr_axi_awaddr,
//  input  wire              tddr_axi_awready,   
//  output wire [1:0]        tddr_axi_awburst,
//  output wire [3:0]        tddr_axi_awcache,
//  output wire[C_M00_AXI_ID_WIDTH-1:0]tddr_axi_awid,
//  output wire [7:0]        tddr_axi_awlen,
//  output wire [0:0]        tddr_axi_awlock,
//  output wire [2:0]        tddr_axi_awprot,
//  output wire [3:0]        tddr_axi_awqos,

//  output wire [3:0]        tddr_axi_awregion,
//  output wire [2:0]        tddr_axi_awsize,
//  output wire            tddr_axi_awvalid,

//  output wire            tddr_axi_bready,
//  output wire            tddr_axi_rready,

//  output wire[C_M00_AXI_DATA_WIDTH-1:0]        tddr_axi_wdata,
//  output wire            tddr_axi_wlast,
//  output wire[C_M00_AXI_DATA_WIDTH/8-1:0]tddr_axi_wstrb,
//  output wire            tddr_axi_wvalid,
//  input  wire            tddr_axi_wready,
//  output wire            tddr_axi_arvalid


  output         rd_yuv_start         ,  
  output [31:0]  rd_yuv_addr          , 

  input          rd_yuv_data_vld      ,
  input [7:0]    rd_yuv_data   
  );
//=============================signal define=============================
 wire     yuv_start;   
 reg [6:0]yuv_start_syn;  
  
 wire[31:0]yuv_addr;   
 reg [31:0]yuv_addr_syn1;    
 reg [31:0]yuv_addr_syn2;    
 reg [31:0]yuv_addr_syn3;  
 reg [31:0]yuv_addr_syn4;   
 reg [31:0]yuv_addr_syn5;   
//=============================module instance============================
//===================================================================
// dispatch control
//===================================================================
dispatch_control dispatch_control(
    .clk_sys                  (ap_clk),
    .rst_sys                  (ap_rst),
    .ddr_initdone             (ddr_initdone),
    .rece_qune                (rece_qune),         
    .send_statue              (send_statue), 
    .send_start               (send_start),  
    .sfp_rd_data              (sfp_rd_data),
    .sfp_wr_en                (sfp_wr_en),
    .sfp_wr_data              (sfp_wr_data), 
//    .rd_yuv_start             (rd_yuv_start),  
//    .rd_yuv_addr              (rd_yuv_addr), 
    .rd_yuv_start             (yuv_start),  
    .rd_yuv_addr              (yuv_addr), 
    .rd_yuv_data_vld          (rd_yuv_data_vld),
    .rd_yuv_data              (rd_yuv_data)
    );  
always @ (posedge ap_clk or posedge ap_rst) begin
  if (ap_rst == 1'b1)begin
    yuv_start_syn <=  0 ;
  end else begin
    yuv_start_syn <=  {yuv_start_syn[5:0],yuv_start} ;
  end
end      
assign rd_yuv_start= yuv_start_syn[6] | yuv_start_syn[5];   
    
always @ (posedge ap_clk or posedge ap_rst) begin
  if (ap_rst == 1'b1)begin
    yuv_addr_syn1 <=  0 ;
    yuv_addr_syn2 <=  0 ;    
    yuv_addr_syn3 <=  0 ;   
    yuv_addr_syn4 <=  0 ;
    yuv_addr_syn5 <=  0 ;           
  end else begin
    yuv_addr_syn1 <=  yuv_addr ;
    yuv_addr_syn2 <=  yuv_addr_syn1 ;    
    yuv_addr_syn3 <=  yuv_addr_syn2 ;   
    yuv_addr_syn4 <=  yuv_addr_syn3 ;
    yuv_addr_syn5 <=  yuv_addr_syn4 ; 
  end
end      
assign rd_yuv_addr = yuv_addr_syn4;          
////===================================================================
//// read ddr data
////===================================================================
//rddr_axi_ctr#(
//  .ADDR_WIDTH (C_M00_AXI_ADDR_WIDTH),
//  .DATA_WIDTH (C_M00_AXI_DATA_WIDTH)  
//  ) rddr_axi_ctr(
//   .clk_sys             (ap_clk),
//   .rst_sys             (ap_rst),

//   .rd_yuv_start        (rd_yuv_start),
//   .rd_yuv_addr         ({34'h0,rd_yuv_addr[31:2]}),
//   .rd_yuv_data_vld     (rd_yuv_data_vld),
//   .rd_yuv_data         (rd_yuv_data),

//   .m_axi_araddr        (tddr_axi_araddr),
//   .m_axi_arlen         (tddr_axi_arlen),   
//   .m_axi_arsize        (tddr_axi_arsize),   
//   .m_axi_arburst       (tddr_axi_arburst),   
////   .m_axi_arlock        (tddr_axi_arlock),   
//   .m_axi_arcache       (tddr_axi_arcache),   
//   .m_axi_arprot        (tddr_axi_arprot),   
//   .m_axi_arqos         (tddr_axi_arqos),   
//   .m_axi_arvalid       (tddr_axi_arvalid),
//   .m_axi_arready       (tddr_axi_arready),
//   .m_axi_rdata         (tddr_axi_rdata),
//   .m_axi_rresp         (2'b00),
//   .m_axi_rlast         (tddr_axi_rlast),
//   .m_axi_rvalid        (tddr_axi_rvalid),
//   .m_axi_rready        (tddr_axi_rready)
//  ); 
  
  
////===================================================================
//// write ddr data
// //===================================================================  
  
//axim_wr_ctrlr axim_wr_ctrlr(
//    .clk_sys           (ap_clk),
//    .rst_sys           (ap_rst),
  
//    .kernel_start      (1'b0),
//    .outbuf_base_addr  (64'h00000000),
  
//    .wr_dn             (),
//    .wr_idle_sign      (),  
//    .w128B_int         (),    
//    .rece_outbuf_ptr   (), 
  
//    .wr_data_ready     (),
//    .wr_data_vld       (1'b0),
//    .wr_axis_data      (1'b0),
//    .wr_data_last      (1'b0),   
//    .wr_data_en        (4'hF),      
  
//    .m_axi_awaddr      (tddr_axi_awaddr),
//    .m_axi_awlen       (tddr_axi_awlen),
//    .m_axi_awsize      (tddr_axi_awsize),
//    .m_axi_awburst     (tddr_axi_awburst),
//    .m_axi_awcache     (tddr_axi_awcache),
//    .m_axi_awvalid     (tddr_axi_awvalid),
//    .m_axi_awready     (tddr_axi_awready),
//    .m_axi_wdata       (tddr_axi_wdata),
//    .m_axi_wstrb       (tddr_axi_wstrb),
//    .m_axi_wlast       (tddr_axi_wlast),
//    .m_axi_wvalid      (tddr_axi_wvalid),
//    .m_axi_wready      (tddr_axi_wready),
//    .m_axi_bresp       (tddr_axi_bresp),
//    .m_axi_bvalid      (tddr_axi_bvalid),
//    .m_axi_bready      (tddr_axi_bready) 
//  );  
endmodule
