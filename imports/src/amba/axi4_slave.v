`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/26 14:24:12
// Design Name: 
// Module Name: ddr_top
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
`default_nettype wire
module axi4_slave# (
    parameter                              C_S_AXI_DATA_WIDTH   = 512,
    parameter                              C_S_AXI_ID_WIDTH     = 1,
    parameter                              C_S_AXI_ADDR_WIDTH   = 32
    )(
    input                                   ap_clk,    
    input                                   s_axi_aclk,
    input                                   s_axi_aresetn,
    input [C_S_AXI_ID_WIDTH-1:0]            s_axi_awid,
    input [C_S_AXI_ADDR_WIDTH-1:0]          s_axi_awaddr,
    input [7:0]                             s_axi_awlen,
    input [2:0]                             s_axi_awsize,
    input [1:0]                             s_axi_awburst,

    input                                   s_axi_awvalid,
    output wire                             s_axi_awready,
    input [C_S_AXI_DATA_WIDTH-1:0]          s_axi_wdata,
    input [C_S_AXI_DATA_WIDTH/8-1:0]        s_axi_wstrb,
    input                                   s_axi_wlast,
    input                                   s_axi_wvalid,
    output                                  s_axi_wready,
    output wire [C_S_AXI_ID_WIDTH-1:0]      s_axi_bid,
    output wire [1:0]                       s_axi_bresp,
    output wire                             s_axi_bvalid,
    input                                   s_axi_bready,

    input [C_S_AXI_ID_WIDTH-1:0]            s_axi_arid,
    input [C_S_AXI_ADDR_WIDTH-1:0]          s_axi_araddr,
    input [7:0]                             s_axi_arlen,
    input [2:0]                             s_axi_arsize,
    input [1:0]                             s_axi_arburst,
    input                                   s_axi_arvalid,
    output wire                             s_axi_arready,
    output     [C_S_AXI_ID_WIDTH-1:0]       s_axi_rid,
    output     [C_S_AXI_DATA_WIDTH-1:0]     s_axi_rdata,
    output     [1:0]                        s_axi_rresp,
    output                                  s_axi_rlast,
    output                                  s_axi_rvalid,
    input                                   s_axi_rready,


    input                         avm_wr_ready,   
    output                        avm_wr_vaild,
    output[C_S_AXI_DATA_WIDTH-1:0]avm_wr_data,       
  
    output                        avm_rd_ready,
    input                         avm_rd_vaild,   
    input[C_S_AXI_DATA_WIDTH-1:0] avm_rd_data 
    );
//=============================paramer define============================= 

wire [31:0]   avm_wr_addres_reg;
wire [31:0]   avm_rd_addres_reg;
//=============================signal define=============================   
    axi4_slavewr #(
    .C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH),
    .C_S_AXI_ID_WIDTH(C_S_AXI_ID_WIDTH),    
    .C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH)   
    )wr(
    .ap_clk(ap_clk),    
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),
    .s_axi_awid(s_axi_awid),
    .s_axi_awaddr(s_axi_awaddr),
    .s_axi_awlen(s_axi_awlen),
    .s_axi_awsize(s_axi_awsize),
    .s_axi_awburst(s_axi_awburst),

    .s_axi_awvalid(s_axi_awvalid),
    .s_axi_awready(s_axi_awready),
    .s_axi_wdata(s_axi_wdata),
    .s_axi_wstrb(s_axi_wstrb),
    .s_axi_wlast(s_axi_wlast),
    .s_axi_wvalid(s_axi_wvalid),
    .s_axi_wready(s_axi_wready),
    .s_axi_bid(s_axi_bid),
    .s_axi_bresp(s_axi_bresp),
    .s_axi_bvalid(s_axi_bvalid),
    .s_axi_bready(s_axi_bready),

    .avm_wr_ready(avm_wr_ready),    
    .avm_wr_vaild(avm_wr_vaild),
    .avm_wr_data(avm_wr_data), 
    .avm_wr_addres(avm_wr_addres_reg)
    );

//===================================================================
// axi read
//===================================================================
    axi4_slaverd #(
    .C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH),
    .C_S_AXI_ID_WIDTH(C_S_AXI_ID_WIDTH),    
    .C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH)   
    )rd(
    .ap_clk(ap_clk),    
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),    
    .s_axi_arid(s_axi_arid),
    .s_axi_araddr(s_axi_araddr),
    .s_axi_arlen(s_axi_arlen),
    .s_axi_arsize(s_axi_arsize),
    .s_axi_arburst(s_axi_arburst),
    .s_axi_arvalid(s_axi_arvalid),
    .s_axi_arready(s_axi_arready),
    .s_axi_rid(s_axi_rid),
    .s_axi_rdata(s_axi_rdata),
    .s_axi_rresp(s_axi_rresp),
    .s_axi_rlast(s_axi_rlast),
    .s_axi_rvalid(s_axi_rvalid),
    .s_axi_rready(s_axi_rready),

    .avm_rd_ready(avm_rd_ready),
    .avm_rd_vaild(avm_rd_vaild),    
    .avm_rd_data(avm_rd_data),
    .avm_rd_addres(avm_rd_addres_reg) 
    );
    
//  ila_pcie  ila_pcie(
// .clk       (s_axi_aclk),
// .probe0    (avm_wr_ready),
// .probe1    (avm_wr_vaild),
// .probe2    (avm_wr_data),
// .probe3    (avm_rd_ready),
// .probe4    (avm_rd_vaild),
// .probe5    (avm_rd_data),
// .probe6    (rd_ready),
// .probe7    (avm_wr_addres),
// .probe8    (avm_rd_addres),
// .probe9    (avm_wr_ready_ddr),
// .probe10   (avm_wr_vaild_ddr),
// .probe11   (avm_rd_ready_ddr),
// .probe12   (avm_rd_vaild_ddr),

// .probe13   (avm_wr_ready_stream),
// .probe14   (avm_wr_vaild_stream),
// .probe15   (avm_rd_ready_stream),
// .probe16   (avm_rd_vaild_stream)
// );  
     
   
endmodule