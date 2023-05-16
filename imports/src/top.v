`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 01/01/2020 17:11:17 PM
// Design Name:
// Module Name: top
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//qsfp 03->kernel 6 qtpx2
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
`default_nettype wire
module top(	
   // Inouts
   inout [63:0]                         ddr3_dq,
   inout [7:0]                        ddr3_dqs_n,
   inout [7:0]                        ddr3_dqs_p,

   // Outputs
   output [14:0]                       ddr3_addr,
   output [2:0]                      ddr3_ba,
   output                                       ddr3_ras_n,
   output                                       ddr3_cas_n,
   output                                       ddr3_we_n,
   output                                       ddr3_reset_n,
   output [0:0]                        ddr3_ck_p,
   output [0:0]                        ddr3_ck_n,
   output [0:0]                       ddr3_cke,
   
   output [0:0]           ddr3_cs_n,
   
   output [7:0]                        ddr3_dm,
   
   output [0:0]                       ddr3_odt,		
		
		
		
		
		
		output led_ddr3,
		
		input [7:0]pci_exp_rxn,
		input [7:0]pci_exp_rxp,
		output [7:0]pci_exp_txn,
		output [7:0]pci_exp_txp,
		input [0:0]sys_clk_clk_n,
		input [0:0]sys_clk_clk_p,
		input sys_ddr_clk_n,
		input sys_ddr_clk_p,
		
        inout         si5338_scl, //i2c clock
        inout         si5338_sda, //i2c data  
        input         Q3_CLK0_GTREFCLK_PAD_N_IN,
        input         Q3_CLK0_GTREFCLK_PAD_P_IN,    
        input [3:0]   QRXN_IN,
        input [3:0]   QRXP_IN,
        output[3:0]   QTXN_OUT,
        output[3:0]   QTXP_OUT,		
           		
        input         Q2_CLK0_GTREFCLK_PAD_N_IN,
        input         Q2_CLK0_GTREFCLK_PAD_P_IN,    
        input [3:0]   RXN_IN,
        input [3:0]   RXP_IN,
        output[3:0]   TXN_OUT,
        output[3:0]   TXP_OUT,        
        output[3:0]   tx_disable,        		
          		
		input sys_rstn,
		input sys_rst_n,
		output fan
    );
//=============================paramer define============================= 
parameter integer C_S_AXI_CONTROL_ADDR_WIDTH = 12;
parameter integer C_S_AXI_CONTROL_DATA_WIDTH = 32;
parameter integer C_M00_AXI_NUM_THREADS = 1;
parameter integer C_M00_AXI_ID_WIDTH = 1;
parameter integer C_M00_AXI_ADDR_WIDTH = 64;
parameter integer C_M00_AXI_DATA_WIDTH = 32;
//=============================signal define=============================
  wire ddr_clk;
  wire i2c_clk;
  wire kernel_clk;
  
  wire [31:0]kernel_reg_araddr;
  wire [2:0]kernel_reg_arprot;
  wire [0:0]kernel_reg_arready;
  wire [0:0]kernel_reg_arvalid;
  wire [31:0]kernel_reg_awaddr;
  wire [2:0]kernel_reg_awprot;
  wire [0:0]kernel_reg_awready;
  wire [0:0]kernel_reg_awvalid;
  wire [0:0]kernel_reg_bready;
  wire [1:0]kernel_reg_bresp;
  wire [0:0]kernel_reg_bvalid;
  wire [31:0]kernel_reg_rdata;
  wire [0:0]kernel_reg_rready;
  wire [1:0]kernel_reg_rresp;
  wire [0:0]kernel_reg_rvalid;
  wire [31:0]kernel_reg_wdata;
  wire [0:0]kernel_reg_wready;
  wire [3:0]kernel_reg_wstrb;
  wire [0:0]kernel_reg_wvalid;
  wire kernel_rstn;

wire [31:0]  pcie_ddr_araddr;
wire [1:0]   pcie_ddr_arburst;
wire [3:0]   pcie_ddr_arcache;
wire [7:0]   pcie_ddr_arlen;
wire [0:0]   pcie_ddr_arlock;
wire [2:0]   pcie_ddr_arprot;
wire [3:0]   pcie_ddr_arqos;
wire         pcie_ddr_arready;
wire [2:0]   pcie_ddr_arsize;
wire         pcie_ddr_arvalid;
wire [31:0]  pcie_ddr_awaddr;
wire [1:0]   pcie_ddr_awburst;
wire [3:0]   pcie_ddr_awcache;
wire [7:0]   pcie_ddr_awlen;
wire [0:0]   pcie_ddr_awlock;
wire [2:0]   pcie_ddr_awprot;
wire [3:0]   pcie_ddr_awqos;
wire         pcie_ddr_awready;
wire [2:0]   pcie_ddr_awsize;
wire         pcie_ddr_awvalid;
wire         pcie_ddr_bready;
wire  [1:0]  pcie_ddr_bresp;
wire         pcie_ddr_bvalid;
wire  [511:0]pcie_ddr_rdata;
wire         pcie_ddr_rlast;
wire         pcie_ddr_rready;
wire  [1:0]  pcie_ddr_rresp;
wire         pcie_ddr_rvalid;
wire [511:0] pcie_ddr_wdata;
wire         pcie_ddr_wlast;
wire         pcie_ddr_wready;
wire [63:0]  pcie_ddr_wstrb;
wire         pcie_ddr_wvalid;


wire         rd_yuv_start         ;  
wire [31:0]  rd_yuv_addr          ; 

wire         rd_yuv_data_vld      ;
wire  [7:0]  rd_yuv_data     ;   


wire         sys_clk_i; 
wire         init_calib_complete;
wire         kernel_rst;


  wire [31:0]pcie_maxi0_araddr;
  wire [1:0]pcie_maxi0_arburst;
  wire [3:0]pcie_maxi0_arcache;
  wire [7:0]pcie_maxi0_arlen;
  wire [0:0]pcie_maxi0_arlock;
  wire [2:0]pcie_maxi0_arprot;
  wire [3:0]pcie_maxi0_arqos;
  wire pcie_maxi0_arready;
  wire [3:0]pcie_maxi0_arregion;
  wire [2:0]pcie_maxi0_arsize;
  wire pcie_maxi0_arvalid;
  wire [31:0]pcie_maxi0_awaddr;
  wire [1:0]pcie_maxi0_awburst;
  wire [3:0]pcie_maxi0_awcache;
  wire [7:0]pcie_maxi0_awlen;
  wire [0:0]pcie_maxi0_awlock;
  wire [2:0]pcie_maxi0_awprot;
  wire [3:0]pcie_maxi0_awqos;
  wire pcie_maxi0_awready;
  wire [3:0]pcie_maxi0_awregion;
  wire [2:0]pcie_maxi0_awsize;
  wire pcie_maxi0_awvalid;
  wire pcie_maxi0_bready;
  wire [1:0]pcie_maxi0_bresp;
  wire pcie_maxi0_bvalid;
  wire [31:0]pcie_maxi0_rdata;
  wire pcie_maxi0_rlast;
  wire pcie_maxi0_rready;
  wire [1:0]pcie_maxi0_rresp;
  wire pcie_maxi0_rvalid;
  wire [31:0]pcie_maxi0_wdata;
  wire pcie_maxi0_wlast;
  wire pcie_maxi0_wready;
  wire [3:0]pcie_maxi0_wstrb;
  wire pcie_maxi0_wvalid;
  wire [31:0]pcie_maxi1_araddr;
  wire [1:0]pcie_maxi1_arburst;
  wire [3:0]pcie_maxi1_arcache;
  wire [7:0]pcie_maxi1_arlen;
  wire [0:0]pcie_maxi1_arlock;
  wire [2:0]pcie_maxi1_arprot;
  wire [3:0]pcie_maxi1_arqos;
  wire pcie_maxi1_arready;
  wire [3:0]pcie_maxi1_arregion;
  wire [2:0]pcie_maxi1_arsize;
  wire pcie_maxi1_arvalid;
  wire [31:0]pcie_maxi1_awaddr;
  wire [1:0]pcie_maxi1_awburst;
  wire [3:0]pcie_maxi1_awcache;
  wire [7:0]pcie_maxi1_awlen;
  wire [0:0]pcie_maxi1_awlock;
  wire [2:0]pcie_maxi1_awprot;
  wire [3:0]pcie_maxi1_awqos;
  wire pcie_maxi1_awready;
  wire [3:0]pcie_maxi1_awregion;
  wire [2:0]pcie_maxi1_awsize;
  wire pcie_maxi1_awvalid;
  wire pcie_maxi1_bready;
  wire [1:0]pcie_maxi1_bresp;
  wire pcie_maxi1_bvalid;
  wire [511:0]pcie_maxi1_rdata;
  wire pcie_maxi1_rlast;
  wire pcie_maxi1_rready;
  wire [1:0]pcie_maxi1_rresp;
  wire pcie_maxi1_rvalid;
  wire [511:0]pcie_maxi1_wdata;
  wire pcie_maxi1_wlast;
  wire pcie_maxi1_wready;
  wire [63:0]pcie_maxi1_wstrb;
  wire pcie_maxi1_wvalid;
 

wire clk_100Mhz;
wire clk_125Mhz;
wire done;
wire [31:0] gtp_status ; 


 wire [6:0]								kernel_send_start;
 wire [6:0]								rece_qune  ;
 wire [6:0]								send_statue; 
 wire [448-1:0]                         sfp_rd_data;
 wire [6:0]								sfp_wr_en;
 wire [448-1:0]                         sfp_wr_data; 

wire [7:0] tx_clk;
wire [31:0]tx_data[7:0];
wire [3:0] tx_kchar[7:0];
wire [7:0] rx_clk;
wire [31:0]rx_data[7:0];
wire [31:0]tx_data_reg[7:0];
wire [3:0] rx_kchar[7:0];
wire [7:0] gt_txfsmresetdone;
wire [7:0] gt_rxfsmresetdone;
wire [64-1:0]                         sfp_rd_data_arry[6:0];
wire [64-1:0]                         sfp_wr_data_arry[6:0]; 
wire                                  ddr_initdone;
wire [1:0]                            usr_irq_ack_0;
wire [1:0]                            usr_irq_req_0; 
wire                                  rece_irq;
wire                                  rece_ack;
wire                                  send_irq;
wire                                  send_ack; 
wire                                  vio_eg;
wire [15:0]                           soft_rstn;



wire        avm_wr_ready;    
wire        avm_wr_vaild;
wire  [511:0]avm_wr_data;        
  
wire        avm_rd_ready;
wire        avm_rd_vaild;    
wire  [31:0]avm_rd_data;

wire         loop_ready;
wire  [31:0] rece_fifo_usedw;
wire  [31:0] send_fifo_usedw; 
wire         test_flag;   
wire         wr_done_ddr;
//=============================module instance============================

//===================================================================
// cfg clock
//===================================================================
clk_wiz_0 clk_wiz_0(
  .clk_out1(sys_clk_i),
  .clk_out2(i2c_clk),
  .clk_out3(clk_100Mhz),
  .clk_out4(clk_125Mhz),  
  .resetn(sys_rstn),
  .locked(),
  .clk_in1_p(sys_ddr_clk_n),
  .clk_in1_n(sys_ddr_clk_p) 
);

//assign kernel_clk=ddr_clk;
assign kernel_clk=clk_125Mhz;

si5338#
 (
     .kInitFileName                  ("si5338_i4_50_200_125_125_100.mif"),
     .input_clk                      (200000000                ),
     .i2c_address                    (7'b1110000               ),
     .bus_clk                        (400000                   )
 )
 si5338_inst(
     .clk                            (i2c_clk                   ),
     .reset                          (~sys_rstn                   ),
     .done                           (done                     ),
     .error                          (                         ),
     .SCL                            (si5338_scl               ),
     .SDA                            (si5338_sda               )
     );
//===================================================================
// system reg
//===================================================================
sys_reg#(
   .ADDR_WIDTH    ( 12 )   ,
   .DATA_WIDTH    ( 32 )   
)sys_reg(
  //system
       .clk_sys                   (  kernel_clk            ) , // input  wire
       .rst_sys                   (  kernel_rst            ) , // input  wire
       .work_en                   ( 1'b1             ) ,

       // AXI4-Lite slave signal
       .awvalid                   ( kernel_reg_awvalid       ) , // input  wire
       .awready                   ( kernel_reg_awready       ) , // output wire
       .awaddr                    ( kernel_reg_awaddr        ) , // input  wire [ADDR_WIDTH-1:0]
       .wvalid                    ( kernel_reg_wvalid        ) , // input  wire
       .wready                    ( kernel_reg_wready        ) , // output wire
       .wdata                     ( kernel_reg_wdata         ) , // input  wire [DATA_WIDTH-1:0]
       .wstrb                     ( kernel_reg_wstrb         ) , // input  wire [DATA_WIDTH/8-1:0]
       .arvalid                   ( kernel_reg_arvalid       ) , // input  wire
       .arready                   ( kernel_reg_arready       ) , // output wire
       .araddr                    ( kernel_reg_araddr        ) , // input  wire [ADDR_WIDTH-1:0]
       .rvalid                    ( kernel_reg_rvalid        ) , // output wire
       .rready                    ( kernel_reg_rready        ) , // input  wire
       .rdata                     ( kernel_reg_rdata         ) , // output wire [DATA_WIDTH-1:0]
       .rresp                     ( kernel_reg_rresp         ) , // output wire [           1:0]
       .bvalid                    ( kernel_reg_bvalid        ) , // output wire
       .bready                    ( kernel_reg_bready        ) , // input  wire
       .bresp                     ( kernel_reg_bresp         ) , // output wire [           1:0]
       .kernel_rst                ( soft_rstn),
       .gtp_status                ( gtp_status),
       .test_flag                 ( test_flag ),
       .rece_ack                  ( rece_ack), 
       .send_ack                  ( send_ack),       
       
       .rece_fifo_usedw           (rece_fifo_usedw),    
       .send_fifo_usedw           (send_fifo_usedw)          
       );
            
 assign led_ddr3=init_calib_complete;   
 //===================================================================
// ddr top
//===================================================================
   ddr_top ddr_top(

  .kernel_clk( kernel_clk),
  .kernel_rstn( kernel_rstn),

  .sys_clk_i( sys_clk_i),
  .sys_rst( sys_rstn),

  .ddr3_addr                      (ddr3_addr),
  .ddr3_ba                        (ddr3_ba),
  .ddr3_cas_n                     (ddr3_cas_n),
  .ddr3_ck_n                      (ddr3_ck_n),
  .ddr3_ck_p                      (ddr3_ck_p),
  .ddr3_cke                       (ddr3_cke),
  .ddr3_ras_n                     (ddr3_ras_n),
  .ddr3_we_n                      (ddr3_we_n),
  .ddr3_dq                        (ddr3_dq),
  .ddr3_dqs_n                     (ddr3_dqs_n),
  .ddr3_dqs_p                     (ddr3_dqs_p),
  .ddr3_reset_n                   (ddr3_reset_n),

  .ddr3_cs_n                      (ddr3_cs_n),
  .ddr3_dm                        (ddr3_dm),
  .ddr3_odt                       (ddr3_odt),
 
  .pcie_ddr_araddr(pcie_ddr_araddr),
  .pcie_ddr_arburst(pcie_ddr_arburst),
  .pcie_ddr_arcache(pcie_ddr_arcache),
  .pcie_ddr_arlen(pcie_ddr_arlen),
  .pcie_ddr_arlock(pcie_ddr_arlock),
  .pcie_ddr_arprot(pcie_ddr_arprot),
  .pcie_ddr_arqos(pcie_ddr_arqos),
  .pcie_ddr_arready(pcie_ddr_arready),
  .pcie_ddr_arsize(pcie_ddr_arsize),
  .pcie_ddr_arvalid(pcie_ddr_arvalid),
  .pcie_ddr_awaddr(pcie_ddr_awaddr),
  .pcie_ddr_awburst(pcie_ddr_awburst),
  .pcie_ddr_awcache(pcie_ddr_awcache),
  .pcie_ddr_awlen(pcie_ddr_awlen),
  .pcie_ddr_awlock(pcie_ddr_awlock),
  .pcie_ddr_awprot(pcie_ddr_awprot),
  .pcie_ddr_awqos(pcie_ddr_awqos),
  .pcie_ddr_awready(pcie_ddr_awready),
  .pcie_ddr_awsize(pcie_ddr_awsize),
  .pcie_ddr_awvalid(pcie_ddr_awvalid),
  .pcie_ddr_bready(pcie_ddr_bready),
  .pcie_ddr_bresp(pcie_ddr_bresp),
  .pcie_ddr_bvalid(pcie_ddr_bvalid),
  .pcie_ddr_rdata(pcie_ddr_rdata),
  .pcie_ddr_rlast(pcie_ddr_rlast),
  .pcie_ddr_rready(pcie_ddr_rready),
  .pcie_ddr_rresp(pcie_ddr_rresp),
  .pcie_ddr_rvalid(pcie_ddr_rvalid),
  .pcie_ddr_wdata(pcie_ddr_wdata),
  .pcie_ddr_wlast(pcie_ddr_wlast),
  .pcie_ddr_wready(pcie_ddr_wready),
  .pcie_ddr_wstrb(pcie_ddr_wstrb),
  .pcie_ddr_wvalid(pcie_ddr_wvalid),  
  
  .init_calib_complete(init_calib_complete ),
  .user_clk            (ddr_clk ),  

  .rd_yuv_start         (rd_yuv_start ),  
  .rd_yuv_addr          (rd_yuv_addr ), 

  .rd_yuv_data_vld      (rd_yuv_data_vld ),
  .rd_yuv_data          (rd_yuv_data )
  );
//===================================================================
// axi bd
//===================================================================
  axi_bd_wrapper axi_bd_wrapper(
  
  
       .pcie_ddr_araddr(pcie_ddr_araddr),
        .pcie_ddr_arburst(pcie_ddr_arburst),
        .pcie_ddr_arcache(pcie_ddr_arcache),
        .pcie_ddr_arlen(pcie_ddr_arlen),
        .pcie_ddr_arlock(pcie_ddr_arlock),
        .pcie_ddr_arprot(pcie_ddr_arprot),
        .pcie_ddr_arqos(pcie_ddr_arqos),
        .pcie_ddr_arready(pcie_ddr_arready),
        .pcie_ddr_arsize(pcie_ddr_arsize),
        .pcie_ddr_arvalid(pcie_ddr_arvalid),
        .pcie_ddr_awaddr(pcie_ddr_awaddr),
        .pcie_ddr_awburst(pcie_ddr_awburst),
        .pcie_ddr_awcache(pcie_ddr_awcache),
        .pcie_ddr_awlen(pcie_ddr_awlen),
        .pcie_ddr_awlock(pcie_ddr_awlock),
        .pcie_ddr_awprot(pcie_ddr_awprot),
        .pcie_ddr_awqos(pcie_ddr_awqos),
        .pcie_ddr_awready(pcie_ddr_awready),
        .pcie_ddr_awsize(pcie_ddr_awsize),
        .pcie_ddr_awvalid(pcie_ddr_awvalid),
        .pcie_ddr_bready(pcie_ddr_bready),
        .pcie_ddr_bresp(pcie_ddr_bresp),
        .pcie_ddr_bvalid(pcie_ddr_bvalid),
        .pcie_ddr_rdata(pcie_ddr_rdata),
        .pcie_ddr_rlast(pcie_ddr_rlast),
        .pcie_ddr_rready(pcie_ddr_rready),
        .pcie_ddr_rresp(pcie_ddr_rresp),
        .pcie_ddr_rvalid(pcie_ddr_rvalid),
        .pcie_ddr_wdata(pcie_ddr_wdata),
        .pcie_ddr_wlast(pcie_ddr_wlast),
        .pcie_ddr_wready(pcie_ddr_wready),
        .pcie_ddr_wstrb(pcie_ddr_wstrb),
        .pcie_ddr_wvalid(pcie_ddr_wvalid),  
  
  
  
        .pcie_maxi0_araddr(pcie_maxi0_araddr),
        .pcie_maxi0_arburst(pcie_maxi0_arburst),
        .pcie_maxi0_arcache(pcie_maxi0_arcache),
        .pcie_maxi0_arlen(pcie_maxi0_arlen),
        .pcie_maxi0_arlock(pcie_maxi0_arlock),
        .pcie_maxi0_arprot(pcie_maxi0_arprot),
        .pcie_maxi0_arqos(pcie_maxi0_arqos),
        .pcie_maxi0_arready(pcie_maxi0_arready),
        .pcie_maxi0_arsize(pcie_maxi0_arsize),
        .pcie_maxi0_arvalid(pcie_maxi0_arvalid),
        .pcie_maxi0_awaddr(pcie_maxi0_awaddr),
        .pcie_maxi0_awburst(pcie_maxi0_awburst),
        .pcie_maxi0_awcache(pcie_maxi0_awcache),
        .pcie_maxi0_awlen(pcie_maxi0_awlen),
        .pcie_maxi0_awlock(pcie_maxi0_awlock),
        .pcie_maxi0_awprot(pcie_maxi0_awprot),
        .pcie_maxi0_awqos(pcie_maxi0_awqos),
        .pcie_maxi0_awready(pcie_maxi0_awready),
        .pcie_maxi0_awsize(pcie_maxi0_awsize),
        .pcie_maxi0_awvalid(pcie_maxi0_awvalid),
        .pcie_maxi0_bready(pcie_maxi0_bready),
        .pcie_maxi0_bresp(pcie_maxi0_bresp),
        .pcie_maxi0_bvalid(pcie_maxi0_bvalid),
        .pcie_maxi0_rdata(pcie_maxi0_rdata),
        .pcie_maxi0_rlast(pcie_maxi0_rlast),
        .pcie_maxi0_rready(pcie_maxi0_rready),
        .pcie_maxi0_rresp(pcie_maxi0_rresp),
        .pcie_maxi0_rvalid(pcie_maxi0_rvalid),
        .pcie_maxi0_wdata(pcie_maxi0_wdata),
        .pcie_maxi0_wlast(pcie_maxi0_wlast),
        .pcie_maxi0_wready(pcie_maxi0_wready),
        .pcie_maxi0_wstrb(pcie_maxi0_wstrb),
        .pcie_maxi0_wvalid(pcie_maxi0_wvalid),
        .pcie_maxi1_araddr(pcie_maxi1_araddr),
        .pcie_maxi1_arburst(pcie_maxi1_arburst),
        .pcie_maxi1_arcache(pcie_maxi1_arcache),
        .pcie_maxi1_arlen(pcie_maxi1_arlen),
        .pcie_maxi1_arlock(pcie_maxi1_arlock),
        .pcie_maxi1_arprot(pcie_maxi1_arprot),
        .pcie_maxi1_arqos(pcie_maxi1_arqos),
        .pcie_maxi1_arready(pcie_maxi1_arready),
        .pcie_maxi1_arsize(pcie_maxi1_arsize),
        .pcie_maxi1_arvalid(pcie_maxi1_arvalid),
        .pcie_maxi1_awaddr(pcie_maxi1_awaddr),
        .pcie_maxi1_awburst(pcie_maxi1_awburst),
        .pcie_maxi1_awcache(pcie_maxi1_awcache),
        .pcie_maxi1_awlen(pcie_maxi1_awlen),
        .pcie_maxi1_awlock(pcie_maxi1_awlock),
        .pcie_maxi1_awprot(pcie_maxi1_awprot),
        .pcie_maxi1_awqos(pcie_maxi1_awqos),
        .pcie_maxi1_awready(pcie_maxi1_awready),
        .pcie_maxi1_awsize(pcie_maxi1_awsize),
        .pcie_maxi1_awvalid(pcie_maxi1_awvalid),
        .pcie_maxi1_bready(pcie_maxi1_bready),
        .pcie_maxi1_bresp(pcie_maxi1_bresp),
        .pcie_maxi1_bvalid(pcie_maxi1_bvalid),
        .pcie_maxi1_rdata(pcie_maxi1_rdata),
        .pcie_maxi1_rlast(pcie_maxi1_rlast),
        .pcie_maxi1_rready(pcie_maxi1_rready),
        .pcie_maxi1_rresp(pcie_maxi1_rresp),
        .pcie_maxi1_rvalid(pcie_maxi1_rvalid),
        .pcie_maxi1_wdata(pcie_maxi1_wdata),
        .pcie_maxi1_wlast(pcie_maxi1_wlast),
        .pcie_maxi1_wready(pcie_maxi1_wready),
        .pcie_maxi1_wstrb(pcie_maxi1_wstrb),
        .pcie_maxi1_wvalid(pcie_maxi1_wvalid),

        .kernel_clk(kernel_clk),
        .ddr_rstn(init_calib_complete),
        
        .kernel_reg_araddr(kernel_reg_araddr),
        .kernel_reg_arprot(kernel_reg_arprot),
        .kernel_reg_arready(kernel_reg_arready),
        .kernel_reg_arvalid(kernel_reg_arvalid),
        .kernel_reg_awaddr(kernel_reg_awaddr),
        .kernel_reg_awprot(kernel_reg_awprot),
        .kernel_reg_awready(kernel_reg_awready),
        .kernel_reg_awvalid(kernel_reg_awvalid),
        .kernel_reg_bready(kernel_reg_bready),
        .kernel_reg_bresp(kernel_reg_bresp),
        .kernel_reg_bvalid(kernel_reg_bvalid),
        .kernel_reg_rdata(kernel_reg_rdata),
        .kernel_reg_rready(kernel_reg_rready),
        .kernel_reg_rresp(kernel_reg_rresp),
        .kernel_reg_rvalid(kernel_reg_rvalid),
        .kernel_reg_wdata(kernel_reg_wdata),
        .kernel_reg_wready(kernel_reg_wready),
        .kernel_reg_wstrb(kernel_reg_wstrb),
        .kernel_reg_wvalid(kernel_reg_wvalid),

        .kernel_rstn(kernel_rstn),
        .kernel_rst(kernel_rst),
        
        .pci_exp_rxn(pci_exp_rxn),
        .pci_exp_rxp(pci_exp_rxp),
        .pci_exp_txn(pci_exp_txn),
        .pci_exp_txp(pci_exp_txp),
        .sys_clk_clk_n(sys_clk_clk_n),
        .sys_clk_clk_p(sys_clk_clk_p),
        .sys_rst_n(sys_rst_n),
        .usr_irq_ack_0(usr_irq_ack_0),
        .usr_irq_req_0(usr_irq_req_0)    
    );
assign fan=1'b0;
//===================================================================
// kernel recev and send 
//===================================================================
generate
  genvar j;
  for(j=0;j<7;j=j+1)begin:arry_data
    assign sfp_wr_data_arry[j]=sfp_wr_data[((j+1)<<6)-1'b1:j<<6];
  end
endgenerate

assign sfp_rd_data={sfp_rd_data_arry[6],sfp_rd_data_arry[5],sfp_rd_data_arry[4],
                    sfp_rd_data_arry[3],sfp_rd_data_arry[2],sfp_rd_data_arry[1],sfp_rd_data_arry[0]};




//    kernel_top inst_dut0 (
//     .ap_clk                ( kernel_clk               ),
//     .ap_rst                (!(kernel_rstn & gt_txfsmresetdone[0]) ),
     
//     .tx_clk                ( tx_clk[0]                  ),
//     .gtp_txdata            ( tx_data_reg[0]                 ),
//     .gtp_txctl             ( tx_kchar[0]                ),
     
//     .rx_clk                ( rx_clk[0]                  ),
//     .gtp_rxdata            ( rx_data[0]                 ),
//     .gtp_rxctl             ( rx_kchar[0]                ),
      
//     .send_start            (kernel_send_start[0]),  
//     .sfp_rd_data           (sfp_rd_data_arry[0]),
//     .sfp_wr_en             (sfp_wr_en[0]),
//     .sfp_wr_data           (sfp_wr_data_arry[0]), 
//     .rece_qune             (rece_qune[0]),
//     .send_statue           (send_statue[0])      
//    );

//assign rece_qune[5:1]=5'd0;
//assign send_statue[5:1]=5'd0;






generate
  genvar i;
  for(i=0;i<6;i=i+1)begin:kernel
    kernel_top inst_dut0 (
     .ap_clk                ( kernel_clk               ),
     .ap_rst                (!(kernel_rstn & gt_txfsmresetdone[i] & soft_rstn[i]) ),
     
     .tx_clk                ( tx_clk[i]                  ),
     .gtp_txdata            ( tx_data_reg[i]                 ),
     .gtp_txctl             ( tx_kchar[i]                ),
     
     .rx_clk                ( rx_clk[i]                  ),
     .gtp_rxdata            ( rx_data[i]                 ),
     .gtp_rxctl             ( rx_kchar[i]                ),
      
     .send_start            (kernel_send_start[i]),  
     .sfp_rd_data           (sfp_rd_data_arry[i]),
     .sfp_wr_en             (sfp_wr_en[i]),
     .sfp_wr_data           (sfp_wr_data_arry[i]), 
     .rece_qune             (rece_qune[i]),
     .send_statue           (send_statue[i])      
    );
  end
endgenerate

assign ddr_initdone =led_ddr3;
generate
genvar l;
  for(l=0;l<6;l=l+1)begin:data
    assign tx_data[l]=((tx_data_reg[l]==32'h00000001)&(test_flag==1'b1))?32'h00010000:tx_data_reg[l];
   end
 endgenerate
 
// test_ila test_ila(
// .clk 	    (kernel_clk),
// .probe0    (test_flag),
// .probe1    (kernel_rstn & soft_rstn[6]),
// .probe2    (ddr_initdone),
// .probe3    (sfp_wr_en),
// .probe4    (kernel_send_start),
// .probe5    (rece_qune),
// .probe6    ({send_statue,gt_txfsmresetdone})
// );
 //===================================================================
 // dispatch for tx data
 //=================================================================== 
dispatch_top dispatch_top(
  // System Sig        nals
  .ap_clk               (kernel_clk),
  .ap_rst               (!(kernel_rstn & soft_rstn[6])),
  .ddr_initdone         (ddr_initdone),
  
  .rece_qune            (rece_qune), 
  .send_statue          (send_statue), 
  
  .send_start           (kernel_send_start),  
  .sfp_rd_data          (sfp_rd_data),
  
  .sfp_wr_en            (sfp_wr_en),
  .sfp_wr_data          (sfp_wr_data), 

  .rd_yuv_start         (rd_yuv_start ),  
  .rd_yuv_addr          (rd_yuv_addr ), 

  .rd_yuv_data_vld      (rd_yuv_data_vld ),
  .rd_yuv_data          (rd_yuv_data ) 
  ); 
 //===================================================================
 // axi control data
 //=================================================================== 
  pcie_stream only_read(
  .ap_clk          (kernel_clk),
  .ap_rstn         (kernel_rstn),
  .pcie_maxi_araddr (pcie_maxi0_araddr),
  .pcie_maxi_arburst(pcie_maxi0_arburst),
  .pcie_maxi_arcache(pcie_maxi0_arcache),
  .pcie_maxi_arlen  (pcie_maxi0_arlen),
  .pcie_maxi_arlock (pcie_maxi0_arlock),
  .pcie_maxi_arprot (pcie_maxi0_arprot),
  .pcie_maxi_arqos  (pcie_maxi0_arqos),
  .pcie_maxi_arready(pcie_maxi0_arready),
  .pcie_maxi_arsize (pcie_maxi0_arsize),
  .pcie_maxi_arvalid(pcie_maxi0_arvalid),
  .pcie_maxi_awaddr (pcie_maxi0_awaddr),
  .pcie_maxi_awburst(pcie_maxi0_awburst),
  .pcie_maxi_awcache(pcie_maxi0_awcache),
  .pcie_maxi_awlen  (pcie_maxi0_awlen),
  .pcie_maxi_awlock (pcie_maxi0_awlock),
  .pcie_maxi_awprot (pcie_maxi0_awprot),
  .pcie_maxi_awqos  (pcie_maxi0_awqos),
  .pcie_maxi_awready(pcie_maxi0_awready),
  .pcie_maxi_awsize (pcie_maxi0_awsize),
  .pcie_maxi_awvalid(pcie_maxi0_awvalid),
  .pcie_maxi_bready (pcie_maxi0_bready),
  .pcie_maxi_bresp  (pcie_maxi0_bresp),
  .pcie_maxi_bvalid (pcie_maxi0_bvalid),
  .pcie_maxi_rdata  (pcie_maxi0_rdata),
  .pcie_maxi_rlast  (pcie_maxi0_rlast),
  .pcie_maxi_rready (pcie_maxi0_rready),
  .pcie_maxi_rresp  (pcie_maxi0_rresp),
  .pcie_maxi_rvalid (pcie_maxi0_rvalid),
  .pcie_maxi_wdata  (pcie_maxi0_wdata),
  .pcie_maxi_wlast  (pcie_maxi0_wlast),
  .pcie_maxi_wready (pcie_maxi0_wready),
  .pcie_maxi_wstrb  (pcie_maxi0_wstrb),
  .pcie_maxi_wvalid (pcie_maxi0_wvalid),

  .avm_wr_ready     (1'b1),    
  .avm_wr_vaild     (),
  .avm_wr_data      (),        

  .avm_rd_ready     (avm_rd_ready),
  .avm_rd_vaild     (avm_rd_vaild),    
  .avm_rd_data      (avm_rd_data)       
  );
 
//  pcie_stream only_write(
//  .ap_clk          (kernel_clk),
//  .ap_rstn         (kernel_rstn),
//  .pcie_maxi_araddr (pcie_maxi1_araddr),
//  .pcie_maxi_arburst(pcie_maxi1_arburst),
//  .pcie_maxi_arcache(pcie_maxi1_arcache),
//  .pcie_maxi_arlen  (pcie_maxi1_arlen),
//  .pcie_maxi_arlock (pcie_maxi1_arlock),
//  .pcie_maxi_arprot (pcie_maxi1_arprot),
//  .pcie_maxi_arqos  (pcie_maxi1_arqos),
//  .pcie_maxi_arready(pcie_maxi1_arready),
//  .pcie_maxi_arsize (pcie_maxi1_arsize),
//  .pcie_maxi_arvalid(pcie_maxi1_arvalid),
//  .pcie_maxi_awaddr (pcie_maxi1_awaddr),
//  .pcie_maxi_awburst(pcie_maxi1_awburst),
//  .pcie_maxi_awcache(pcie_maxi1_awcache),
//  .pcie_maxi_awlen  (pcie_maxi1_awlen),
//  .pcie_maxi_awlock (pcie_maxi1_awlock),
//  .pcie_maxi_awprot (pcie_maxi1_awprot),
//  .pcie_maxi_awqos  (pcie_maxi1_awqos),
//  .pcie_maxi_awready(pcie_maxi1_awready),
//  .pcie_maxi_awsize (pcie_maxi1_awsize),
//  .pcie_maxi_awvalid(pcie_maxi1_awvalid),
//  .pcie_maxi_bready (pcie_maxi1_bready),
//  .pcie_maxi_bresp  (pcie_maxi1_bresp),
//  .pcie_maxi_bvalid (pcie_maxi1_bvalid),
//  .pcie_maxi_rdata  (pcie_maxi1_rdata),
//  .pcie_maxi_rlast  (pcie_maxi1_rlast),
//  .pcie_maxi_rready (pcie_maxi1_rready),
//  .pcie_maxi_rresp  (pcie_maxi1_rresp),
//  .pcie_maxi_rvalid (pcie_maxi1_rvalid),
//  .pcie_maxi_wdata  (pcie_maxi1_wdata),
//  .pcie_maxi_wlast  (pcie_maxi1_wlast),
//  .pcie_maxi_wready (pcie_maxi1_wready),
//  .pcie_maxi_wstrb  (pcie_maxi1_wstrb),
//  .pcie_maxi_wvalid (pcie_maxi1_wvalid),

//  .avm_wr_ready     (avm_wr_ready),    
//  .avm_wr_vaild     (avm_wr_vaild),
//  .avm_wr_data      (avm_wr_data),        

//  .avm_rd_ready     (loop_ready),
//  .avm_rd_vaild     (loop_ready),    
//  .avm_rd_data      (0)       
//  ); 
 
    axi4_slave #(
    .C_S_AXI_DATA_WIDTH(512),
    .C_S_AXI_ID_WIDTH(1),    
    .C_S_AXI_ADDR_WIDTH(32)   
    )axi4_slave(
    .ap_clk             (kernel_clk),
    .s_axi_aclk         (kernel_clk),
    .s_axi_aresetn      (kernel_rstn),
    .s_axi_awid         (pcie_maxi1_awid),
    .s_axi_awaddr       (pcie_maxi1_awaddr),
    .s_axi_awlen        (pcie_maxi1_awlen),
    .s_axi_awsize       (pcie_maxi1_awsize),
    .s_axi_awburst      (pcie_maxi1_awburst),

    .s_axi_awvalid      (pcie_maxi1_awvalid),
    .s_axi_awready      (pcie_maxi1_awready),
    .s_axi_wdata        (pcie_maxi1_wdata),
    .s_axi_wstrb        (pcie_maxi1_wstrb),
    .s_axi_wlast        (pcie_maxi1_wlast),
    .s_axi_wvalid       (pcie_maxi1_wvalid),
    .s_axi_wready       (pcie_maxi1_wready),
    .s_axi_bid          (pcie_maxi1_bid),
    .s_axi_bresp        (pcie_maxi1_bresp),
    .s_axi_bvalid       (pcie_maxi1_bvalid),
    .s_axi_bready       (pcie_maxi1_bready),
    .s_axi_arid         (pcie_maxi1_arid),
    .s_axi_araddr       (pcie_maxi1_araddr),
    .s_axi_arlen        (pcie_maxi1_arlen),
    .s_axi_arsize       (pcie_maxi1_arsize),
    .s_axi_arburst      (pcie_maxi1_arburst),
    .s_axi_arvalid      (pcie_maxi1_arvalid),
    .s_axi_arready      (pcie_maxi1_arready),
    .s_axi_rid          (pcie_maxi1_rid),
    .s_axi_rdata        (pcie_maxi1_rdata),
    .s_axi_rresp        (pcie_maxi1_rresp),
    .s_axi_rlast        (pcie_maxi1_rlast),
    .s_axi_rvalid       (pcie_maxi1_rvalid),
    .s_axi_rready       (pcie_maxi1_rready),

    .avm_wr_ready     (avm_wr_ready),    
    .avm_wr_vaild     (avm_wr_vaild),
    .avm_wr_data      (avm_wr_data),        

    .avm_rd_ready     (loop_ready),
    .avm_rd_vaild     (loop_ready),    
    .avm_rd_data      (0)       
    );  
 
 
 prxtx_top prxtx_top(
  .ap_clk               (kernel_clk),
  .ap_rst               (!kernel_rstn),

  .send_start           (kernel_send_start[6]),  
  .sfp_rd_data          (sfp_rd_data_arry[6]),

  .sfp_wr_en            (sfp_wr_en[6]),
  .sfp_wr_data          (sfp_wr_data_arry[6]), 

  .rece_qune            (rece_qune[6]),             
  .send_statue          (send_statue[6]),

  .rece_irq             (rece_irq),
  .rece_ack             (rece_ack), 
  .send_irq             (send_irq),
  .send_ack             (send_ack),

  .avm_wr_ready         (avm_wr_ready),    
  .avm_wr_vaild         (avm_wr_vaild),
  .avm_wr_data          (avm_wr_data),        

  .avm_rd_ready         (avm_rd_ready),
  .avm_rd_vaild         (avm_rd_vaild),    
  .avm_rd_data          (avm_rd_data),
  
  .rece_fifo_usedw      (rece_fifo_usedw),    
  .send_fifo_usedw      (send_fifo_usedw)   
  ); 
  
  
  
(*mark_debug = "true"*)reg [31:0] send_cnt;  
(*mark_debug = "true"*)reg [31:0] receive_cnt;    
always @ (posedge kernel_clk or posedge kernel_rstn) begin
  if (kernel_rstn == 1'b0)begin
    send_cnt <=  0 ;
  end else if(avm_wr_ready & avm_wr_vaild)begin
    send_cnt <=  send_cnt+1'b1 ;
  end
end   

always @ (posedge kernel_clk or posedge kernel_rstn) begin
  if (kernel_rstn == 1'b0)begin
    receive_cnt <=  0 ;
  end else if(avm_rd_ready & avm_rd_vaild)begin
    receive_cnt <=  receive_cnt+1'b1 ;
  end
end 
//===================================================================
// interupt control
//=================================================================== 
int_ctr int_ctr(
  .dma_axi_aclk(kernel_clk),
  .dma_axi_aresetn(kernel_rstn), 

  .interrupt_ack  (usr_irq_ack_0),
  .pcie_interrupt (usr_irq_req_0),	

  .kernel_int0(rece_irq),
  .kernel_ack0(rece_ack),  
  .kernel_int1(send_irq),
  .kernel_ack1(send_ack) 
  );
//===================================================================
//gtp
//===================================================================      
      gtx_exdes gtx_exdes_m0
         (
      .tx0_clk(tx_clk[0]),
         .tx0_data(tx_data[0]),
         .tx0_kchar(tx_kchar[0]),   
         .rx0_clk(rx_clk[0]),
         .rx0_data(rx_data[0]),
         .rx0_kchar(rx_kchar[0]),
         .gt0_txfsmresetdone(gt_txfsmresetdone[0]),    
  //       .gt0_rxfsmresetdone(gt_rxfsmresetdone[0]),
         
         .tx1_clk(tx_clk[1]),    
         .tx1_data(tx_data[1]),
         .tx1_kchar(tx_kchar[1]),   
         .rx1_clk(rx_clk[1]),
         .rx1_data(rx_data[1]),
         .rx1_kchar(rx_kchar[1]),
         .gt1_txfsmresetdone(gt_txfsmresetdone[1]),    
  //       .gt1_rxfsmresetdone(gt_rxfsmresetdone[1]),
          
         .tx2_clk(tx_clk[2]),       
         .tx2_data(tx_data[2]),
         .tx2_kchar(tx_kchar[2]),   
         .rx2_clk(rx_clk[2]),
         .rx2_data(rx_data[2]),
         .rx2_kchar(rx_kchar[2]),
         .gt2_txfsmresetdone(gt_txfsmresetdone[2]),    
  //       .gt2_rxfsmresetdone(gt_rxfsmresetdone[2]),
     
         .tx3_clk(tx_clk[3]),
         .tx3_data(tx_data[3]),
         .tx3_kchar(tx_kchar[3]),   
         .rx3_clk(rx_clk[3]),
         .rx3_data(rx_data[3]),
         .rx3_kchar(rx_kchar[3]),
         .gt3_txfsmresetdone(gt_txfsmresetdone[3]),    
  //      .gt3_rxfsmresetdone(gt_rxfsmresetdone[3]),  
                                               
      .Q2_CLK0_GTREFCLK_PAD_N_IN(Q2_CLK0_GTREFCLK_PAD_N_IN),
      .Q2_CLK0_GTREFCLK_PAD_P_IN(Q2_CLK0_GTREFCLK_PAD_P_IN),
      .drp_clk(clk_100Mhz),
      .RXN_IN(RXN_IN),
      .RXP_IN(RXP_IN),
      .TXN_OUT(TXN_OUT),
      .TXP_OUT(TXP_OUT)
     );  
  //===================================================================
  //qgtp
  //===================================================================      
  qgtx_exdes qgtx_exdes_m0
      (
//      .tx0_clk(tx_clk[4]),
//         .tx0_data(tx_data[4]),
//         .tx0_kchar(tx_kchar[4]),   
//         .rx0_clk(rx_clk[4]),
//         .rx0_data(rx_data[4]),
//         .rx0_kchar(rx_kchar[4]),
//         .gt0_txfsmresetdone(gt_txfsmresetdone[4]),    
//  //       .gt0_rxfsmresetdone(gt_rxfsmresetdone[4]),
         
//         .tx1_clk(tx_clk[5]),    
//         .tx1_data(tx_data[5]),
//         .tx1_kchar(tx_kchar[5]),   
//         .rx1_clk(rx_clk[5]),
//         .rx1_data(rx_data[5]),
//         .rx1_kchar(rx_kchar[5]),
//         .gt1_txfsmresetdone(gt_txfsmresetdone[5]),    
//  //       .gt1_rxfsmresetdone(gt_rxfsmresetdone[5]),
          
//         .tx2_clk(tx_clk[6]),       
//         .tx2_data(tx_data[6]),
//         .tx2_kchar(tx_kchar[6]),   
//         .rx2_clk(rx_clk[6]),
//         .rx2_data(rx_data[6]),
//         .rx2_kchar(rx_kchar[6]),
//         .gt2_txfsmresetdone(gt_txfsmresetdone[6]),    
//  //       .gt2_rxfsmresetdone(gt_rxfsmresetdone[6]),
     
//         .tx3_clk(tx_clk[7]),
//         .tx3_data(tx_data[7]),
//         .tx3_kchar(tx_kchar[7]),   
//         .rx3_clk(rx_clk[7]),
//         .rx3_data(rx_data[7]),
//         .rx3_kchar(rx_kchar[7]),
//         .gt3_txfsmresetdone(gt_txfsmresetdone[7]),    
//  //      .gt3_rxfsmresetdone(gt_rxfsmresetdone[7]),    
     
      .tx0_clk(tx_clk[6]),
   .tx0_data(tx_data[6]),
   .tx0_kchar(tx_kchar[6]),   
   .rx0_clk(rx_clk[6]),
   .rx0_data(rx_data[6]),
   .rx0_kchar(rx_kchar[6]),
   .gt0_txfsmresetdone(gt_txfsmresetdone[6]),    
//       .gt0_rxfsmresetdone(gt_rxfsmresetdone[4]),
   
   .tx1_clk(tx_clk[5]),    
   .tx1_data(tx_data[5]),
   .tx1_kchar(tx_kchar[5]),   
   .rx1_clk(rx_clk[5]),
   .rx1_data(rx_data[5]),
   .rx1_kchar(rx_kchar[5]),
   .gt1_txfsmresetdone(gt_txfsmresetdone[5]),    
//       .gt1_rxfsmresetdone(gt_rxfsmresetdone[5]),
    
   .tx2_clk(tx_clk[4]),       
   .tx2_data(tx_data[4]),
   .tx2_kchar(tx_kchar[4]),   
   .rx2_clk(rx_clk[4]),
   .rx2_data(rx_data[4]),
   .rx2_kchar(rx_kchar[4]),
   .gt2_txfsmresetdone(gt_txfsmresetdone[4]),    
//       .gt2_rxfsmresetdone(gt_rxfsmresetdone[6]),

   .tx3_clk(tx_clk[7]),
   .tx3_data(tx_data[7]),
   .tx3_kchar(tx_kchar[7]),   
   .rx3_clk(rx_clk[7]),
   .rx3_data(rx_data[7]),
   .rx3_kchar(rx_kchar[7]),
   .gt3_txfsmresetdone(gt_txfsmresetdone[7]),    
//      .gt3_rxfsmresetdone(gt_rxfsmresetdone[7]),       
                           
          .Q2_CLK0_GTREFCLK_PAD_N_IN(Q3_CLK0_GTREFCLK_PAD_N_IN),
          .Q2_CLK0_GTREFCLK_PAD_P_IN(Q3_CLK0_GTREFCLK_PAD_P_IN),
          .drp_clk(clk_100Mhz),
          .RXN_IN(QRXN_IN),
          .RXP_IN(QRXP_IN),
          .TXN_OUT(QTXN_OUT),
          .TXP_OUT(QTXP_OUT)    
  );

assign gtp_status= {gt_txfsmresetdone, gt_rxfsmresetdone};
assign tx_disable = 4'd0;
endmodule