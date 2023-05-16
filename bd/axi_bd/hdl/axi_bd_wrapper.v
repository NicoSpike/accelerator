//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
//Date        : Thu Feb 16 22:26:15 2023
//Host        : DESKTOP-JV4JRIL running 64-bit major release  (build 9200)
//Command     : generate_target axi_bd_wrapper.bd
//Design      : axi_bd_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module axi_bd_wrapper
   (ddr_rstn,
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
    kernel_rst,
    kernel_rstn,
    msi_enable,
    pci_exp_rxn,
    pci_exp_rxp,
    pci_exp_txn,
    pci_exp_txp,
    pcie_ddr_araddr,
    pcie_ddr_arburst,
    pcie_ddr_arcache,
    pcie_ddr_arlen,
    pcie_ddr_arlock,
    pcie_ddr_arprot,
    pcie_ddr_arqos,
    pcie_ddr_arready,
    pcie_ddr_arregion,
    pcie_ddr_arsize,
    pcie_ddr_arvalid,
    pcie_ddr_awaddr,
    pcie_ddr_awburst,
    pcie_ddr_awcache,
    pcie_ddr_awlen,
    pcie_ddr_awlock,
    pcie_ddr_awprot,
    pcie_ddr_awqos,
    pcie_ddr_awready,
    pcie_ddr_awregion,
    pcie_ddr_awsize,
    pcie_ddr_awvalid,
    pcie_ddr_bready,
    pcie_ddr_bresp,
    pcie_ddr_bvalid,
    pcie_ddr_rdata,
    pcie_ddr_rlast,
    pcie_ddr_rready,
    pcie_ddr_rresp,
    pcie_ddr_rvalid,
    pcie_ddr_wdata,
    pcie_ddr_wlast,
    pcie_ddr_wready,
    pcie_ddr_wstrb,
    pcie_ddr_wvalid,
    pcie_maxi0_araddr,
    pcie_maxi0_arburst,
    pcie_maxi0_arcache,
    pcie_maxi0_arlen,
    pcie_maxi0_arlock,
    pcie_maxi0_arprot,
    pcie_maxi0_arqos,
    pcie_maxi0_arready,
    pcie_maxi0_arregion,
    pcie_maxi0_arsize,
    pcie_maxi0_arvalid,
    pcie_maxi0_awaddr,
    pcie_maxi0_awburst,
    pcie_maxi0_awcache,
    pcie_maxi0_awlen,
    pcie_maxi0_awlock,
    pcie_maxi0_awprot,
    pcie_maxi0_awqos,
    pcie_maxi0_awready,
    pcie_maxi0_awregion,
    pcie_maxi0_awsize,
    pcie_maxi0_awvalid,
    pcie_maxi0_bready,
    pcie_maxi0_bresp,
    pcie_maxi0_bvalid,
    pcie_maxi0_rdata,
    pcie_maxi0_rlast,
    pcie_maxi0_rready,
    pcie_maxi0_rresp,
    pcie_maxi0_rvalid,
    pcie_maxi0_wdata,
    pcie_maxi0_wlast,
    pcie_maxi0_wready,
    pcie_maxi0_wstrb,
    pcie_maxi0_wvalid,
    pcie_maxi1_araddr,
    pcie_maxi1_arburst,
    pcie_maxi1_arcache,
    pcie_maxi1_arlen,
    pcie_maxi1_arlock,
    pcie_maxi1_arprot,
    pcie_maxi1_arqos,
    pcie_maxi1_arready,
    pcie_maxi1_arregion,
    pcie_maxi1_arsize,
    pcie_maxi1_arvalid,
    pcie_maxi1_awaddr,
    pcie_maxi1_awburst,
    pcie_maxi1_awcache,
    pcie_maxi1_awlen,
    pcie_maxi1_awlock,
    pcie_maxi1_awprot,
    pcie_maxi1_awqos,
    pcie_maxi1_awready,
    pcie_maxi1_awregion,
    pcie_maxi1_awsize,
    pcie_maxi1_awvalid,
    pcie_maxi1_bready,
    pcie_maxi1_bresp,
    pcie_maxi1_bvalid,
    pcie_maxi1_rdata,
    pcie_maxi1_rlast,
    pcie_maxi1_rready,
    pcie_maxi1_rresp,
    pcie_maxi1_rvalid,
    pcie_maxi1_wdata,
    pcie_maxi1_wlast,
    pcie_maxi1_wready,
    pcie_maxi1_wstrb,
    pcie_maxi1_wvalid,
    sys_clk_clk_n,
    sys_clk_clk_p,
    sys_rst_n,
    user_lnk_up,
    usr_irq_ack_0,
    usr_irq_req_0);
  input ddr_rstn;
  input kernel_clk;
  output [31:0]kernel_reg_araddr;
  output [2:0]kernel_reg_arprot;
  input kernel_reg_arready;
  output kernel_reg_arvalid;
  output [31:0]kernel_reg_awaddr;
  output [2:0]kernel_reg_awprot;
  input kernel_reg_awready;
  output kernel_reg_awvalid;
  output kernel_reg_bready;
  input [1:0]kernel_reg_bresp;
  input kernel_reg_bvalid;
  input [31:0]kernel_reg_rdata;
  output kernel_reg_rready;
  input [1:0]kernel_reg_rresp;
  input kernel_reg_rvalid;
  output [31:0]kernel_reg_wdata;
  input kernel_reg_wready;
  output [3:0]kernel_reg_wstrb;
  output kernel_reg_wvalid;
  output kernel_rst;
  output [0:0]kernel_rstn;
  output msi_enable;
  input [7:0]pci_exp_rxn;
  input [7:0]pci_exp_rxp;
  output [7:0]pci_exp_txn;
  output [7:0]pci_exp_txp;
  output [31:0]pcie_ddr_araddr;
  output [1:0]pcie_ddr_arburst;
  output [3:0]pcie_ddr_arcache;
  output [7:0]pcie_ddr_arlen;
  output [0:0]pcie_ddr_arlock;
  output [2:0]pcie_ddr_arprot;
  output [3:0]pcie_ddr_arqos;
  input pcie_ddr_arready;
  output [3:0]pcie_ddr_arregion;
  output [2:0]pcie_ddr_arsize;
  output pcie_ddr_arvalid;
  output [31:0]pcie_ddr_awaddr;
  output [1:0]pcie_ddr_awburst;
  output [3:0]pcie_ddr_awcache;
  output [7:0]pcie_ddr_awlen;
  output [0:0]pcie_ddr_awlock;
  output [2:0]pcie_ddr_awprot;
  output [3:0]pcie_ddr_awqos;
  input pcie_ddr_awready;
  output [3:0]pcie_ddr_awregion;
  output [2:0]pcie_ddr_awsize;
  output pcie_ddr_awvalid;
  output pcie_ddr_bready;
  input [1:0]pcie_ddr_bresp;
  input pcie_ddr_bvalid;
  input [511:0]pcie_ddr_rdata;
  input pcie_ddr_rlast;
  output pcie_ddr_rready;
  input [1:0]pcie_ddr_rresp;
  input pcie_ddr_rvalid;
  output [511:0]pcie_ddr_wdata;
  output pcie_ddr_wlast;
  input pcie_ddr_wready;
  output [63:0]pcie_ddr_wstrb;
  output pcie_ddr_wvalid;
  output [31:0]pcie_maxi0_araddr;
  output [1:0]pcie_maxi0_arburst;
  output [3:0]pcie_maxi0_arcache;
  output [7:0]pcie_maxi0_arlen;
  output [0:0]pcie_maxi0_arlock;
  output [2:0]pcie_maxi0_arprot;
  output [3:0]pcie_maxi0_arqos;
  input pcie_maxi0_arready;
  output [3:0]pcie_maxi0_arregion;
  output [2:0]pcie_maxi0_arsize;
  output pcie_maxi0_arvalid;
  output [31:0]pcie_maxi0_awaddr;
  output [1:0]pcie_maxi0_awburst;
  output [3:0]pcie_maxi0_awcache;
  output [7:0]pcie_maxi0_awlen;
  output [0:0]pcie_maxi0_awlock;
  output [2:0]pcie_maxi0_awprot;
  output [3:0]pcie_maxi0_awqos;
  input pcie_maxi0_awready;
  output [3:0]pcie_maxi0_awregion;
  output [2:0]pcie_maxi0_awsize;
  output pcie_maxi0_awvalid;
  output pcie_maxi0_bready;
  input [1:0]pcie_maxi0_bresp;
  input pcie_maxi0_bvalid;
  input [31:0]pcie_maxi0_rdata;
  input pcie_maxi0_rlast;
  output pcie_maxi0_rready;
  input [1:0]pcie_maxi0_rresp;
  input pcie_maxi0_rvalid;
  output [31:0]pcie_maxi0_wdata;
  output pcie_maxi0_wlast;
  input pcie_maxi0_wready;
  output [3:0]pcie_maxi0_wstrb;
  output pcie_maxi0_wvalid;
  output [31:0]pcie_maxi1_araddr;
  output [1:0]pcie_maxi1_arburst;
  output [3:0]pcie_maxi1_arcache;
  output [7:0]pcie_maxi1_arlen;
  output [0:0]pcie_maxi1_arlock;
  output [2:0]pcie_maxi1_arprot;
  output [3:0]pcie_maxi1_arqos;
  input pcie_maxi1_arready;
  output [3:0]pcie_maxi1_arregion;
  output [2:0]pcie_maxi1_arsize;
  output pcie_maxi1_arvalid;
  output [31:0]pcie_maxi1_awaddr;
  output [1:0]pcie_maxi1_awburst;
  output [3:0]pcie_maxi1_awcache;
  output [7:0]pcie_maxi1_awlen;
  output [0:0]pcie_maxi1_awlock;
  output [2:0]pcie_maxi1_awprot;
  output [3:0]pcie_maxi1_awqos;
  input pcie_maxi1_awready;
  output [3:0]pcie_maxi1_awregion;
  output [2:0]pcie_maxi1_awsize;
  output pcie_maxi1_awvalid;
  output pcie_maxi1_bready;
  input [1:0]pcie_maxi1_bresp;
  input pcie_maxi1_bvalid;
  input [511:0]pcie_maxi1_rdata;
  input pcie_maxi1_rlast;
  output pcie_maxi1_rready;
  input [1:0]pcie_maxi1_rresp;
  input pcie_maxi1_rvalid;
  output [511:0]pcie_maxi1_wdata;
  output pcie_maxi1_wlast;
  input pcie_maxi1_wready;
  output [63:0]pcie_maxi1_wstrb;
  output pcie_maxi1_wvalid;
  input [0:0]sys_clk_clk_n;
  input [0:0]sys_clk_clk_p;
  input sys_rst_n;
  output user_lnk_up;
  output [1:0]usr_irq_ack_0;
  input [1:0]usr_irq_req_0;

  wire ddr_rstn;
  wire kernel_clk;
  wire [31:0]kernel_reg_araddr;
  wire [2:0]kernel_reg_arprot;
  wire kernel_reg_arready;
  wire kernel_reg_arvalid;
  wire [31:0]kernel_reg_awaddr;
  wire [2:0]kernel_reg_awprot;
  wire kernel_reg_awready;
  wire kernel_reg_awvalid;
  wire kernel_reg_bready;
  wire [1:0]kernel_reg_bresp;
  wire kernel_reg_bvalid;
  wire [31:0]kernel_reg_rdata;
  wire kernel_reg_rready;
  wire [1:0]kernel_reg_rresp;
  wire kernel_reg_rvalid;
  wire [31:0]kernel_reg_wdata;
  wire kernel_reg_wready;
  wire [3:0]kernel_reg_wstrb;
  wire kernel_reg_wvalid;
  wire kernel_rst;
  wire [0:0]kernel_rstn;
  wire msi_enable;
  wire [7:0]pci_exp_rxn;
  wire [7:0]pci_exp_rxp;
  wire [7:0]pci_exp_txn;
  wire [7:0]pci_exp_txp;
  wire [31:0]pcie_ddr_araddr;
  wire [1:0]pcie_ddr_arburst;
  wire [3:0]pcie_ddr_arcache;
  wire [7:0]pcie_ddr_arlen;
  wire [0:0]pcie_ddr_arlock;
  wire [2:0]pcie_ddr_arprot;
  wire [3:0]pcie_ddr_arqos;
  wire pcie_ddr_arready;
  wire [3:0]pcie_ddr_arregion;
  wire [2:0]pcie_ddr_arsize;
  wire pcie_ddr_arvalid;
  wire [31:0]pcie_ddr_awaddr;
  wire [1:0]pcie_ddr_awburst;
  wire [3:0]pcie_ddr_awcache;
  wire [7:0]pcie_ddr_awlen;
  wire [0:0]pcie_ddr_awlock;
  wire [2:0]pcie_ddr_awprot;
  wire [3:0]pcie_ddr_awqos;
  wire pcie_ddr_awready;
  wire [3:0]pcie_ddr_awregion;
  wire [2:0]pcie_ddr_awsize;
  wire pcie_ddr_awvalid;
  wire pcie_ddr_bready;
  wire [1:0]pcie_ddr_bresp;
  wire pcie_ddr_bvalid;
  wire [511:0]pcie_ddr_rdata;
  wire pcie_ddr_rlast;
  wire pcie_ddr_rready;
  wire [1:0]pcie_ddr_rresp;
  wire pcie_ddr_rvalid;
  wire [511:0]pcie_ddr_wdata;
  wire pcie_ddr_wlast;
  wire pcie_ddr_wready;
  wire [63:0]pcie_ddr_wstrb;
  wire pcie_ddr_wvalid;
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
  wire [0:0]sys_clk_clk_n;
  wire [0:0]sys_clk_clk_p;
  wire sys_rst_n;
  wire user_lnk_up;
  wire [1:0]usr_irq_ack_0;
  wire [1:0]usr_irq_req_0;

  axi_bd axi_bd_i
       (.ddr_rstn(ddr_rstn),
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
        .kernel_rst(kernel_rst),
        .kernel_rstn(kernel_rstn),
        .msi_enable(msi_enable),
        .pci_exp_rxn(pci_exp_rxn),
        .pci_exp_rxp(pci_exp_rxp),
        .pci_exp_txn(pci_exp_txn),
        .pci_exp_txp(pci_exp_txp),
        .pcie_ddr_araddr(pcie_ddr_araddr),
        .pcie_ddr_arburst(pcie_ddr_arburst),
        .pcie_ddr_arcache(pcie_ddr_arcache),
        .pcie_ddr_arlen(pcie_ddr_arlen),
        .pcie_ddr_arlock(pcie_ddr_arlock),
        .pcie_ddr_arprot(pcie_ddr_arprot),
        .pcie_ddr_arqos(pcie_ddr_arqos),
        .pcie_ddr_arready(pcie_ddr_arready),
        .pcie_ddr_arregion(pcie_ddr_arregion),
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
        .pcie_ddr_awregion(pcie_ddr_awregion),
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
        .pcie_maxi0_arregion(pcie_maxi0_arregion),
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
        .pcie_maxi0_awregion(pcie_maxi0_awregion),
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
        .pcie_maxi1_arregion(pcie_maxi1_arregion),
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
        .pcie_maxi1_awregion(pcie_maxi1_awregion),
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
        .sys_clk_clk_n(sys_clk_clk_n),
        .sys_clk_clk_p(sys_clk_clk_p),
        .sys_rst_n(sys_rst_n),
        .user_lnk_up(user_lnk_up),
        .usr_irq_ack_0(usr_irq_ack_0),
        .usr_irq_req_0(usr_irq_req_0));
endmodule
