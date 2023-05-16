`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 01/01/2020 17:11:17 PM
// Design Name:
// Module Name: sys_reg
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
module sys_reg#(
  parameter   ADDR_WIDTH   =  12             ,
  parameter   DATA_WIDTH   =  32             ,
  parameter   VER_DATE     =  32'h20200830   ,
  parameter   VER_ID       =  32'h78787878
)(
  //system
  input  wire                      clk_sys             ,
  input  wire                      rst_sys             ,
  input  wire                      work_en             ,

  // AXI4-Lite slave signal
  input  wire                      awvalid             ,
  output wire                      awready             ,
  input  wire [ADDR_WIDTH-1:0]     awaddr              ,
  input  wire                      wvalid              ,
  output wire                      wready              ,
  input  wire [DATA_WIDTH-1:0]     wdata               ,
  input  wire [DATA_WIDTH/8-1:0]   wstrb               ,
  input  wire                      arvalid             ,
  output wire                      arready             ,
  input  wire [ADDR_WIDTH-1:0]     araddr              ,
  output wire                      rvalid              ,
  input  wire                      rready              ,
  output wire [DATA_WIDTH-1:0]     rdata               ,
  output wire [           1:0]     rresp               ,
  output wire                      bvalid              ,
  input  wire                      bready              ,
  output wire [           1:0]     bresp               ,

  input wire  [31:0]              gtp_status           , 
  //resizer_kenel
  output wire  [15:0]              kernel_rst          , 
  output wire                      test_flag           ,
  input  wire  [31:0]  			   rece_fifo_usedw     ,
  input  wire  [31:0]  			   send_fifo_usedw     , 
    
  output reg                       send_ack            ,
  output reg                       rece_ack                      
);

//======================================================================================================
//paramer define
//======================================================================================================
localparam         TIME_CNT     = 32'h0ee6_b280 ; //1s
//AXI WRITE/READ FSM
localparam         SM_WRIDLE                      =   2'd0   ,
                   SM_WRDATA                      =   2'd1   ,
                   SM_WRRESP                      =   2'd2   ,
                   SM_RDIDLE                      =   2'd0   ,
                   SM_RDADDR                      =   2'd1   ,
                   SM_RDDATA                      =   2'd2   ;

localparam         ADDR_CTRL_RST                  = 12'h000  ;
localparam         ADDR_FPGA_DATA                 = 12'h004  ;
localparam         ADDR_FPGA_DNA0                 = 12'h008  ;
localparam         ADDR_FPGA_DNA1                 = 12'h00C  ;
localparam         ADDR_FPGA_DNA2                 = 12'h010  ;
localparam         ADDR_FPGA_TEST                 = 12'h014  ;
localparam         ADDR_GTP_STATUS                = 12'h018  ;

localparam         ADDR_SEND_FIFO                 = 12'h020  ;
localparam         ADDR_SEND_ACK                  = 12'h024  ;
localparam         ADDR_RECE_FIFO                 = 12'h028  ;
localparam         ADDR_RECE_ACK                  = 12'h02C  ;

//======================================================================================================
//signal define
//======================================================================================================

 reg  [  1: 0]     w_curr_state        ;
 reg  [  1: 0]     w_next_state        ;
 reg  [  1: 0]     r_curr_state        ;
 reg  [  1: 0]     r_next_state        ;
 wire [ 31: 0]     wmask               ;
 wire              aw_hs               ;
 wire              w_hs                ;
 reg  [ 11: 0]     waddr               ;
 reg               wen                 ;
 reg  [ 31: 0]     wdata_tmp           ;

 reg  [ 31: 0]     rdata_tmp           ;
 wire              ar_hs               ;
 reg  [ 11: 0]     raddr               ;
 wire              ren                 ;
 reg  [15:0]       kernel_rst_reg	   ;
 wire [ 95: 0]     DeviceDna           ;
 reg  [ 31: 0]     test_data           ;
 wire [31:0]        send_length;
 wire [31:0]        send_length_byte;
//======================================================================================================
//main code
//======================================================================================================

//------------------------------------------------------------------------------------------------------
//AXI write
//------------------------------------------------------------------------------------------------------

assign awready = (~rst_sys) & (w_curr_state == SM_WRIDLE);
assign wready  = (w_curr_state == SM_WRDATA);
assign bresp   = 2'b00;
assign bvalid  = (w_curr_state == SM_WRRESP);
assign wmask   = { {8{wstrb[3]}}, {8{wstrb[2]}}, {8{wstrb[1]}}, {8{wstrb[0]}} };
assign aw_hs   = awvalid & awready;
assign w_hs    = wvalid & wready;

//w_curr_state
always @(posedge clk_sys or posedge rst_sys)
begin
  if (rst_sys == 1'b1)begin
    w_curr_state <= SM_WRIDLE;
  end
  else begin
    w_curr_state <= w_next_state;
  end
end

// wnext
always @(*) begin
  case (w_curr_state)
    SM_WRIDLE:
      if (awvalid)
        w_next_state = SM_WRDATA;
      else
        w_next_state = SM_WRIDLE;
    SM_WRDATA:
      if (wvalid)
        w_next_state = SM_WRRESP;
      else
        w_next_state = SM_WRDATA;
    SM_WRRESP:
      if (bready)
        w_next_state = SM_WRIDLE;
      else
        w_next_state = SM_WRRESP;
    default:
        w_next_state = SM_WRIDLE;
  endcase
end

// waddr
always @(posedge clk_sys or posedge rst_sys)
begin
  if (rst_sys == 1'b1)begin
    waddr  <= 12'd0 ;
  end
  else if (aw_hs == 1'b1) begin
    waddr <= awaddr[11:0] ;
  end
  else ;
end
// write enable
always @(posedge clk_sys or posedge rst_sys)
begin
  if (rst_sys == 1'b1)begin
    wen <= 1'd0 ;
  end
  else begin
    wen <= w_hs ;
  end
end
// write data
always @(posedge clk_sys or posedge rst_sys)
begin
  if (rst_sys == 1'b1)begin
    wdata_tmp  <= 32'd0 ;
  end
  else if(w_hs == 1'b1)begin
    wdata_tmp <= wdata & wmask ;
  end
  else ;
end

//------------------------------------------------------------------------------------------------------
//AXI read
//------------------------------------------------------------------------------------------------------

assign arready = (~rst_sys) && (r_curr_state == SM_RDIDLE);
assign rdata   = rdata_tmp;
assign rresp   = 2'b00;  // OKAY
assign rvalid  = (r_curr_state == SM_RDDATA);
assign ar_hs   = arvalid & arready;
assign ren     = rready & rvalid;

// rstate
always @(posedge clk_sys or posedge rst_sys)
begin
  if (rst_sys == 1'b1)begin
    r_curr_state <= SM_RDIDLE ;
  end
  else begin
    r_curr_state <= r_next_state ;
  end
end

// rnext
always @(*) begin
  case (r_curr_state)
    SM_RDIDLE:
      if (arvalid)
        r_next_state = SM_RDADDR;
      else
        r_next_state = SM_RDIDLE;
    SM_RDADDR:
        r_next_state = SM_RDDATA;
    SM_RDDATA:
      if (rready & rvalid)
        r_next_state = SM_RDIDLE;
      else
        r_next_state = SM_RDDATA;
    default:
        r_next_state = SM_RDIDLE;
  endcase
end

always @(posedge clk_sys or posedge rst_sys)
begin
  if (rst_sys == 1'b1)begin
    raddr  <= 12'd0 ;
  end
  else if (arready & arvalid) begin
    raddr <= araddr[11:0];
  end
  else ;
end
assign send_length=(send_fifo_usedw>=32'd500)?32'd0:32'd500-send_fifo_usedw;
assign send_length_byte=send_length<<6;
//------------------------------------------------------------------------------------------------------
// config register read
//------------------------------------------------------------------------------------------------------

always @(posedge clk_sys or posedge rst_sys)
begin
  if (rst_sys == 1'b1)begin
      rdata_tmp <= 32'd0 ;
  end
  else begin
      case (raddr)
          //kernel state
          ADDR_CTRL_RST                : rdata_tmp     <= kernel_rst_reg ;
          ADDR_FPGA_DATA               : rdata_tmp     <= VER_DATE;			  
          ADDR_FPGA_DNA0               : rdata_tmp     <= DeviceDna[31:0];		  
          ADDR_FPGA_DNA1               : rdata_tmp     <= DeviceDna[63:32];		  
          ADDR_FPGA_DNA2               : rdata_tmp     <= DeviceDna[95:64];
          ADDR_FPGA_TEST               : rdata_tmp     <= test_data;
          ADDR_GTP_STATUS              : rdata_tmp     <= gtp_status;
           
          ADDR_SEND_FIFO               : rdata_tmp     <= send_length_byte;		  
          ADDR_SEND_ACK                : rdata_tmp     <= send_ack;
          ADDR_RECE_FIFO               : rdata_tmp     <= rece_fifo_usedw;
          ADDR_RECE_ACK                : rdata_tmp     <= rece_ack;                  
          default                      : rdata_tmp     <= 32'd0 ;
      endcase
  end
end
//------------------------------------------------------------------------------------------------------
// config register write
//------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------
//kernel start
always @ (posedge clk_sys or posedge rst_sys)
begin
   if(rst_sys == 1'b1)begin
      kernel_rst_reg <= 16'b0 ;
   end
   else if(wen && (waddr == ADDR_CTRL_RST) & work_en) begin
      kernel_rst_reg <= wdata_tmp[15:0] ;
   end
end
assign kernel_rst = kernel_rst_reg;
//kernel RST
always @ (posedge clk_sys or posedge rst_sys)
begin
   if(rst_sys == 1'b1)begin
      test_data <= 32'd1 ;
   end
   else if(wen && (waddr == ADDR_FPGA_TEST) & work_en) begin
      test_data <= wdata_tmp ;
   end
end
assign test_flag =test_data[0];
//kernel SEND ACK
always @ (posedge clk_sys or posedge rst_sys)
begin
   if(rst_sys == 1'b1)begin
      send_ack <= 1'd0 ;
   end
   else if(wen && (waddr == ADDR_SEND_ACK) & work_en) begin
      send_ack <= 1'b1 ;
   end else begin
      send_ack <= 1'b0 ;
   end    
end

//kernel RECE ACK
always @ (posedge clk_sys or posedge rst_sys)
begin
   if(rst_sys == 1'b1)begin
      rece_ack <= 1'd0 ;
   end
   else if(wen && (waddr == ADDR_RECE_ACK) & work_en) begin
      rece_ack <= 1'b1 ;
   end else begin
      rece_ack <= 1'b0 ;
   end    
end
 /////////////////////////
//	read_dna read_dna_inst (
//		.ap_clk(clk_sys),
//		.areset(rst_sys),
//		.read_done(),
//		.device_dna(DeviceDna)
//	);       
endmodule