//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
//Date        : Sat Jun  6 11:09:55 2020
//Host        : HHUEFDX6IK4E8XW running 64-bit Service Pack 1  (build 7601)
//Command     : generate_target PCIe_wrapper.bd
//Design      : PCIe_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module PCIe_wrapper
   (DDR3_addr,
    DDR3_ba,
    DDR3_cas_n,
    DDR3_ck_n,
    DDR3_ck_p,
    DDR3_cke,
    DDR3_cs_n,
    DDR3_dm,
    DDR3_dq,
    DDR3_dqs_n,
    DDR3_dqs_p,
    DDR3_odt,
    DDR3_ras_n,
    DDR3_reset_n,
    DDR3_we_n,
    clk_100Mhz,
    ddr_clk,
    dma_axi_araddr,
    dma_axi_arburst,
    dma_axi_arcache,
    dma_axi_arid,
    dma_axi_arlen,
    dma_axi_arlock,
    dma_axi_arprot,
    dma_axi_arqos,
    dma_axi_arready,
    dma_axi_arregion,
    dma_axi_arsize,
    dma_axi_arvalid,
    dma_axi_awaddr,
    dma_axi_awburst,
    dma_axi_awcache,
    dma_axi_awid,
    dma_axi_awlen,
    dma_axi_awlock,
    dma_axi_awprot,
    dma_axi_awqos,
    dma_axi_awready,
    dma_axi_awregion,
    dma_axi_awsize,
    dma_axi_awvalid,
    dma_axi_bid,
    dma_axi_bready,
    dma_axi_bresp,
    dma_axi_bvalid,
    dma_axi_rdata,
    dma_axi_rid,
    dma_axi_rlast,
    dma_axi_rready,
    dma_axi_rresp,
    dma_axi_rvalid,
    dma_axi_wdata,
    dma_axi_wlast,
    dma_axi_wready,
    dma_axi_wstrb,
    dma_axi_wvalid,
    dma_lite_araddr,
    dma_lite_arprot,
    dma_lite_arready,
    dma_lite_arvalid,
    dma_lite_awaddr,
    dma_lite_awprot,
    dma_lite_awready,
    dma_lite_awvalid,
    dma_lite_bready,
    dma_lite_bresp,
    dma_lite_bvalid,
    dma_lite_rdata,
    dma_lite_rready,
    dma_lite_rresp,
    dma_lite_rvalid,
    dma_lite_wdata,
    dma_lite_wready,
    dma_lite_wstrb,
    dma_lite_wvalid,
    kernel_clk,
    kernel_reg_araddr,
    kernel_reg_arprot,
    kernel_reg_arready,
    kernel_reg_arvalid,
    kernel_reg_awaddr,
    kernel_reg_awprot,
    kernel_reg_awready,
    kernel_reg_awvalid,
    kernel_reg_bready,
    kernel_reg_bresp,
    kernel_reg_bvalid,
    kernel_reg_rdata,
    kernel_reg_rready,
    kernel_reg_rresp,
    kernel_reg_rvalid,
    kernel_reg_wdata,
    kernel_reg_wready,
    kernel_reg_wstrb,
    kernel_reg_wvalid,
    kernel_rstn,
    led_ddr3,
    mddr_axi_araddr,
    mddr_axi_arburst,
    mddr_axi_arcache,
    mddr_axi_arid,
    mddr_axi_arlen,
    mddr_axi_arlock,
    mddr_axi_arprot,
    mddr_axi_arqos,
    mddr_axi_arready,
    mddr_axi_arregion,
    mddr_axi_arsize,
    mddr_axi_arvalid,
    mddr_axi_rdata,
    mddr_axi_rid,
    mddr_axi_rlast,
    mddr_axi_rready,
    mddr_axi_rresp,
    mddr_axi_rvalid,
    msi_enable,
    pci_exp_rxn,
    pci_exp_rxp,
    pci_exp_txn,
    pci_exp_txp,
    sys_clk_clk_n,
    sys_clk_clk_p,
    sys_ddr_clk_n,
    sys_ddr_clk_p,
    sys_rst_n,
    sys_rstn,
    user_lnk_up,
    usr_irq_ack_0,
    usr_irq_req_0);
  output [14:0]DDR3_addr;
  output [2:0]DDR3_ba;
  output DDR3_cas_n;
  output [0:0]DDR3_ck_n;
  output [0:0]DDR3_ck_p;
  output [0:0]DDR3_cke;
  output [0:0]DDR3_cs_n;
  output [7:0]DDR3_dm;
  inout [63:0]DDR3_dq;
  inout [7:0]DDR3_dqs_n;
  inout [7:0]DDR3_dqs_p;
  output [0:0]DDR3_odt;
  output DDR3_ras_n;
  output DDR3_reset_n;
  output DDR3_we_n;
  output clk_100Mhz;
  output ddr_clk;
  input [63:0]dma_axi_araddr;
  input [1:0]dma_axi_arburst;
  input [3:0]dma_axi_arcache;
  input [0:0]dma_axi_arid;
  input [7:0]dma_axi_arlen;
  input [0:0]dma_axi_arlock;
  input [2:0]dma_axi_arprot;
  input [3:0]dma_axi_arqos;
  output dma_axi_arready;
  input [3:0]dma_axi_arregion;
  input [2:0]dma_axi_arsize;
  input dma_axi_arvalid;
  input [63:0]dma_axi_awaddr;
  input [1:0]dma_axi_awburst;
  input [3:0]dma_axi_awcache;
  input [0:0]dma_axi_awid;
  input [7:0]dma_axi_awlen;
  input [0:0]dma_axi_awlock;
  input [2:0]dma_axi_awprot;
  input [3:0]dma_axi_awqos;
  output dma_axi_awready;
  input [3:0]dma_axi_awregion;
  input [2:0]dma_axi_awsize;
  input dma_axi_awvalid;
  output [0:0]dma_axi_bid;
  input dma_axi_bready;
  output [1:0]dma_axi_bresp;
  output dma_axi_bvalid;
  output [31:0]dma_axi_rdata;
  output [0:0]dma_axi_rid;
  output dma_axi_rlast;
  input dma_axi_rready;
  output [1:0]dma_axi_rresp;
  output dma_axi_rvalid;
  input [31:0]dma_axi_wdata;
  input dma_axi_wlast;
  output dma_axi_wready;
  input [3:0]dma_axi_wstrb;
  input dma_axi_wvalid;
  output [31:0]dma_lite_araddr;
  output [2:0]dma_lite_arprot;
  input [0:0]dma_lite_arready;
  output [0:0]dma_lite_arvalid;
  output [31:0]dma_lite_awaddr;
  output [2:0]dma_lite_awprot;
  input [0:0]dma_lite_awready;
  output [0:0]dma_lite_awvalid;
  output [0:0]dma_lite_bready;
  input [1:0]dma_lite_bresp;
  input [0:0]dma_lite_bvalid;
  input [31:0]dma_lite_rdata;
  output [0:0]dma_lite_rready;
  input [1:0]dma_lite_rresp;
  input [0:0]dma_lite_rvalid;
  output [31:0]dma_lite_wdata;
  input [0:0]dma_lite_wready;
  output [3:0]dma_lite_wstrb;
  output [0:0]dma_lite_wvalid;
  output kernel_clk;
  output [31:0]kernel_reg_araddr;
  output [2:0]kernel_reg_arprot;
  input [0:0]kernel_reg_arready;
  output [0:0]kernel_reg_arvalid;
  output [31:0]kernel_reg_awaddr;
  output [2:0]kernel_reg_awprot;
  input [0:0]kernel_reg_awready;
  output [0:0]kernel_reg_awvalid;
  output [0:0]kernel_reg_bready;
  input [1:0]kernel_reg_bresp;
  input [0:0]kernel_reg_bvalid;
  input [31:0]kernel_reg_rdata;
  output [0:0]kernel_reg_rready;
  input [1:0]kernel_reg_rresp;
  input [0:0]kernel_reg_rvalid;
  output [31:0]kernel_reg_wdata;
  input [0:0]kernel_reg_wready;
  output [3:0]kernel_reg_wstrb;
  output [0:0]kernel_reg_wvalid;
  output kernel_rstn;
  output led_ddr3;
  input [63:0]mddr_axi_araddr;
  input [1:0]mddr_axi_arburst;
  input [3:0]mddr_axi_arcache;
  input [0:0]mddr_axi_arid;
  input [7:0]mddr_axi_arlen;
  input [0:0]mddr_axi_arlock;
  input [2:0]mddr_axi_arprot;
  input [3:0]mddr_axi_arqos;
  output mddr_axi_arready;
  input [3:0]mddr_axi_arregion;
  input [2:0]mddr_axi_arsize;
  input mddr_axi_arvalid;
  output [31:0]mddr_axi_rdata;
  output [0:0]mddr_axi_rid;
  output mddr_axi_rlast;
  input mddr_axi_rready;
  output [1:0]mddr_axi_rresp;
  output mddr_axi_rvalid;
  output msi_enable;
  input [7:0]pci_exp_rxn;
  input [7:0]pci_exp_rxp;
  output [7:0]pci_exp_txn;
  output [7:0]pci_exp_txp;
  input [0:0]sys_clk_clk_n;
  input [0:0]sys_clk_clk_p;
  input sys_ddr_clk_n;
  input sys_ddr_clk_p;
  input sys_rst_n;
  input sys_rstn;
  output user_lnk_up;
  output [1:0]usr_irq_ack_0;
  input [1:0]usr_irq_req_0;

  wire [14:0]DDR3_addr;
  wire [2:0]DDR3_ba;
  wire DDR3_cas_n;
  wire [0:0]DDR3_ck_n;
  wire [0:0]DDR3_ck_p;
  wire [0:0]DDR3_cke;
  wire [0:0]DDR3_cs_n;
  wire [7:0]DDR3_dm;
  wire [63:0]DDR3_dq;
  wire [7:0]DDR3_dqs_n;
  wire [7:0]DDR3_dqs_p;
  wire [0:0]DDR3_odt;
  wire DDR3_ras_n;
  wire DDR3_reset_n;
  wire DDR3_we_n;
  wire clk_100Mhz;
  wire ddr_clk;
  wire [63:0]dma_axi_araddr;
  wire [1:0]dma_axi_arburst;
  wire [3:0]dma_axi_arcache;
  wire [0:0]dma_axi_arid;
  wire [7:0]dma_axi_arlen;
  wire [0:0]dma_axi_arlock;
  wire [2:0]dma_axi_arprot;
  wire [3:0]dma_axi_arqos;
  wire dma_axi_arready;
  wire [3:0]dma_axi_arregion;
  wire [2:0]dma_axi_arsize;
  wire dma_axi_arvalid;
  wire [63:0]dma_axi_awaddr;
  wire [1:0]dma_axi_awburst;
  wire [3:0]dma_axi_awcache;
  wire [0:0]dma_axi_awid;
  wire [7:0]dma_axi_awlen;
  wire [0:0]dma_axi_awlock;
  wire [2:0]dma_axi_awprot;
  wire [3:0]dma_axi_awqos;
  wire dma_axi_awready;
  wire [3:0]dma_axi_awregion;
  wire [2:0]dma_axi_awsize;
  wire dma_axi_awvalid;
  wire [0:0]dma_axi_bid;
  wire dma_axi_bready;
  wire [1:0]dma_axi_bresp;
  wire dma_axi_bvalid;
  wire [31:0]dma_axi_rdata;
  wire [0:0]dma_axi_rid;
  wire dma_axi_rlast;
  wire dma_axi_rready;
  wire [1:0]dma_axi_rresp;
  wire dma_axi_rvalid;
  wire [31:0]dma_axi_wdata;
  wire dma_axi_wlast;
  wire dma_axi_wready;
  wire [3:0]dma_axi_wstrb;
  wire dma_axi_wvalid;
  wire [31:0]dma_lite_araddr;
  wire [2:0]dma_lite_arprot;
  wire [0:0]dma_lite_arready;
  wire [0:0]dma_lite_arvalid;
  wire [31:0]dma_lite_awaddr;
  wire [2:0]dma_lite_awprot;
  wire [0:0]dma_lite_awready;
  wire [0:0]dma_lite_awvalid;
  wire [0:0]dma_lite_bready;
  wire [1:0]dma_lite_bresp;
  wire [0:0]dma_lite_bvalid;
  wire [31:0]dma_lite_rdata;
  wire [0:0]dma_lite_rready;
  wire [1:0]dma_lite_rresp;
  wire [0:0]dma_lite_rvalid;
  wire [31:0]dma_lite_wdata;
  wire [0:0]dma_lite_wready;
  wire [3:0]dma_lite_wstrb;
  wire [0:0]dma_lite_wvalid;
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
  wire led_ddr3;
  wire [63:0]mddr_axi_araddr;
  wire [1:0]mddr_axi_arburst;
  wire [3:0]mddr_axi_arcache;
  wire [0:0]mddr_axi_arid;
  wire [7:0]mddr_axi_arlen;
  wire [0:0]mddr_axi_arlock;
  wire [2:0]mddr_axi_arprot;
  wire [3:0]mddr_axi_arqos;
  wire mddr_axi_arready;
  wire [3:0]mddr_axi_arregion;
  wire [2:0]mddr_axi_arsize;
  wire mddr_axi_arvalid;
  wire [31:0]mddr_axi_rdata;
  wire [0:0]mddr_axi_rid;
  wire mddr_axi_rlast;
  wire mddr_axi_rready;
  wire [1:0]mddr_axi_rresp;
  wire mddr_axi_rvalid;
  wire msi_enable;
  wire [7:0]pci_exp_rxn;
  wire [7:0]pci_exp_rxp;
  wire [7:0]pci_exp_txn;
  wire [7:0]pci_exp_txp;
  wire [0:0]sys_clk_clk_n;
  wire [0:0]sys_clk_clk_p;
  wire sys_ddr_clk_n;
  wire sys_ddr_clk_p;
  wire sys_rst_n;
  wire sys_rstn;
  wire user_lnk_up;
  wire [1:0]usr_irq_ack_0;
  wire [1:0]usr_irq_req_0;

  PCIe PCIe_i
       (.DDR3_addr(DDR3_addr),
        .DDR3_ba(DDR3_ba),
        .DDR3_cas_n(DDR3_cas_n),
        .DDR3_ck_n(DDR3_ck_n),
        .DDR3_ck_p(DDR3_ck_p),
        .DDR3_cke(DDR3_cke),
        .DDR3_cs_n(DDR3_cs_n),
        .DDR3_dm(DDR3_dm),
        .DDR3_dq(DDR3_dq),
        .DDR3_dqs_n(DDR3_dqs_n),
        .DDR3_dqs_p(DDR3_dqs_p),
        .DDR3_odt(DDR3_odt),
        .DDR3_ras_n(DDR3_ras_n),
        .DDR3_reset_n(DDR3_reset_n),
        .DDR3_we_n(DDR3_we_n),
        .clk_100Mhz(clk_100Mhz),
        .ddr_clk(ddr_clk),
        .dma_axi_araddr(dma_axi_araddr),
        .dma_axi_arburst(dma_axi_arburst),
        .dma_axi_arcache(dma_axi_arcache),
        .dma_axi_arid(dma_axi_arid),
        .dma_axi_arlen(dma_axi_arlen),
        .dma_axi_arlock(dma_axi_arlock),
        .dma_axi_arprot(dma_axi_arprot),
        .dma_axi_arqos(dma_axi_arqos),
        .dma_axi_arready(dma_axi_arready),
        .dma_axi_arregion(dma_axi_arregion),
        .dma_axi_arsize(dma_axi_arsize),
        .dma_axi_arvalid(dma_axi_arvalid),
        .dma_axi_awaddr(dma_axi_awaddr),
        .dma_axi_awburst(dma_axi_awburst),
        .dma_axi_awcache(dma_axi_awcache),
        .dma_axi_awid(dma_axi_awid),
        .dma_axi_awlen(dma_axi_awlen),
        .dma_axi_awlock(dma_axi_awlock),
        .dma_axi_awprot(dma_axi_awprot),
        .dma_axi_awqos(dma_axi_awqos),
        .dma_axi_awready(dma_axi_awready),
        .dma_axi_awregion(dma_axi_awregion),
        .dma_axi_awsize(dma_axi_awsize),
        .dma_axi_awvalid(dma_axi_awvalid),
        .dma_axi_bid(dma_axi_bid),
        .dma_axi_bready(dma_axi_bready),
        .dma_axi_bresp(dma_axi_bresp),
        .dma_axi_bvalid(dma_axi_bvalid),
        .dma_axi_rdata(dma_axi_rdata),
        .dma_axi_rid(dma_axi_rid),
        .dma_axi_rlast(dma_axi_rlast),
        .dma_axi_rready(dma_axi_rready),
        .dma_axi_rresp(dma_axi_rresp),
        .dma_axi_rvalid(dma_axi_rvalid),
        .dma_axi_wdata(dma_axi_wdata),
        .dma_axi_wlast(dma_axi_wlast),
        .dma_axi_wready(dma_axi_wready),
        .dma_axi_wstrb(dma_axi_wstrb),
        .dma_axi_wvalid(dma_axi_wvalid),
        .dma_lite_araddr(dma_lite_araddr),
        .dma_lite_arprot(dma_lite_arprot),
        .dma_lite_arready(dma_lite_arready),
        .dma_lite_arvalid(dma_lite_arvalid),
        .dma_lite_awaddr(dma_lite_awaddr),
        .dma_lite_awprot(dma_lite_awprot),
        .dma_lite_awready(dma_lite_awready),
        .dma_lite_awvalid(dma_lite_awvalid),
        .dma_lite_bready(dma_lite_bready),
        .dma_lite_bresp(dma_lite_bresp),
        .dma_lite_bvalid(dma_lite_bvalid),
        .dma_lite_rdata(dma_lite_rdata),
        .dma_lite_rready(dma_lite_rready),
        .dma_lite_rresp(dma_lite_rresp),
        .dma_lite_rvalid(dma_lite_rvalid),
        .dma_lite_wdata(dma_lite_wdata),
        .dma_lite_wready(dma_lite_wready),
        .dma_lite_wstrb(dma_lite_wstrb),
        .dma_lite_wvalid(dma_lite_wvalid),
        .kernel_clk(kernel_clk),
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
        .led_ddr3(led_ddr3),
        .mddr_axi_araddr(mddr_axi_araddr),
        .mddr_axi_arburst(mddr_axi_arburst),
        .mddr_axi_arcache(mddr_axi_arcache),
        .mddr_axi_arid(mddr_axi_arid),
        .mddr_axi_arlen(mddr_axi_arlen),
        .mddr_axi_arlock(mddr_axi_arlock),
        .mddr_axi_arprot(mddr_axi_arprot),
        .mddr_axi_arqos(mddr_axi_arqos),
        .mddr_axi_arready(mddr_axi_arready),
        .mddr_axi_arregion(mddr_axi_arregion),
        .mddr_axi_arsize(mddr_axi_arsize),
        .mddr_axi_arvalid(mddr_axi_arvalid),
        .mddr_axi_rdata(mddr_axi_rdata),
        .mddr_axi_rid(mddr_axi_rid),
        .mddr_axi_rlast(mddr_axi_rlast),
        .mddr_axi_rready(mddr_axi_rready),
        .mddr_axi_rresp(mddr_axi_rresp),
        .mddr_axi_rvalid(mddr_axi_rvalid),
        .msi_enable(msi_enable),
        .pci_exp_rxn(pci_exp_rxn),
        .pci_exp_rxp(pci_exp_rxp),
        .pci_exp_txn(pci_exp_txn),
        .pci_exp_txp(pci_exp_txp),
        .sys_clk_clk_n(sys_clk_clk_n),
        .sys_clk_clk_p(sys_clk_clk_p),
        .sys_ddr_clk_n(sys_ddr_clk_n),
        .sys_ddr_clk_p(sys_ddr_clk_p),
        .sys_rst_n(sys_rst_n),
        .sys_rstn(sys_rstn),
        .user_lnk_up(user_lnk_up),
        .usr_irq_ack_0(usr_irq_ack_0),
        .usr_irq_req_0(usr_irq_req_0));
endmodule
