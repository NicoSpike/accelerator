// default_nettype of none prevents implicit wire declaration.
`default_nettype none
`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/14/2020 09:39:08 AM
// Design Name: 
// Module Name: axi_lite
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
module kernel_axi_lite #(
  parameter integer C_ADDR_WIDTH = 12,
  parameter integer C_DATA_WIDTH = 32
)(
  // AXI4-Lite slave signals
  input  wire                      aclk      ,
  input  wire                      areset    ,
  input  wire                      aclk_en   ,
  input  wire                      awvalid   ,
  output wire                      awready   ,
  input  wire [C_ADDR_WIDTH-1:0]   awaddr    ,
  input  wire                      wvalid    ,
  output wire                      wready    ,
  input  wire [C_DATA_WIDTH-1:0]   wdata     ,
  input  wire [C_DATA_WIDTH/8-1:0] wstrb     ,
  input  wire                      arvalid   ,
  output wire                      arready   ,
  input  wire [C_ADDR_WIDTH-1:0]   araddr    ,
  output wire                      rvalid    ,
  input  wire                      rready    ,
  output wire [C_DATA_WIDTH-1:0]   rdata     ,
  output wire [2-1:0]              rresp     ,
  output wire                      bvalid    ,
  input  wire                      bready    ,
  output wire [2-1:0]              bresp     ,

  //user define signal 
  //sfp send
  output wire                      send_start,
  output wire  [32-1:0]            send_length,
  output wire  [32-1:0]            send_inbuf_ptr,
  input  wire                      send_init,
  input  wire [32-1:0]             send_buff_statue,

  //sfp recevice
  input  wire  [32-1:0]            rece_outbuf_ptr,
  input  wire                      rece_init,
  // irq
  output wire                       rece_irq,
  output wire                       rece_ack, 
                
  output wire                       send_irq,
  output wire                       send_ack,
  //debug
  input  wire  [32-1:0]             rx_buf_status,
  input  wire  [32-1:0]             tx_buf_status     
  );
///////////////////////////////////////////////////////////////////////////////
// Local Parameters
///////////////////////////////////////////////////////////////////////////////
localparam integer                  LP_SM_WIDTH                    = 2;
localparam [LP_SM_WIDTH-1:0]        SM_WRIDLE                      = 2'd0;
localparam [LP_SM_WIDTH-1:0]        SM_WRDATA                      = 2'd1;
localparam [LP_SM_WIDTH-1:0]        SM_WRRESP                      = 2'd2;

localparam [LP_SM_WIDTH-1:0]        SM_RDIDLE                      = 2'd0;
localparam [LP_SM_WIDTH-1:0]        SM_RDADDR                      = 2'd1;
localparam [LP_SM_WIDTH-1:0]        SM_RDDATA                      = 2'd2;


localparam [C_ADDR_WIDTH-1:0]       LP_ADDR_SEND_CTRL              = 12'h000;
localparam [C_ADDR_WIDTH-1:0]       LP_ADDR_SEND_LENG              = 12'h004;
localparam [C_ADDR_WIDTH-1:0]       LP_ADDR_SEND_INBUF             = 12'h008;
localparam [C_ADDR_WIDTH-1:0]       LP_ADDR_SEND_ACK               = 12'h00c;
localparam [C_ADDR_WIDTH-1:0]       LP_ADDR_SEND_FIFO              = 12'h010;


localparam [C_ADDR_WIDTH-1:0]       LP_ADDR_RECE_STATU             = 12'h100;
localparam [C_ADDR_WIDTH-1:0]       LP_ADDR_RECE_LAST              = 12'h104;
localparam [C_ADDR_WIDTH-1:0]       LP_ADDR_RECE_BEFORE            = 12'h108;
localparam [C_ADDR_WIDTH-1:0]       LP_ADDR_RECE_OUTBUF            = 12'h10C;
localparam [C_ADDR_WIDTH-1:0]       LP_ADDR_RECE_OUTBUF_START      = 12'h110;
localparam [C_ADDR_WIDTH-1:0]       LP_ADDR_RECE_ACK               = 12'h114;
localparam [C_ADDR_WIDTH-1:0]       LP_ADDR_RECE_FIFO              = 12'h118;
///////////////////////////////////////////////////////////////////////////////
// Wires and Variables
///////////////////////////////////////////////////////////////////////////////
reg  [LP_SM_WIDTH-1:0]              wstate                         = SM_WRIDLE;
reg  [LP_SM_WIDTH-1:0]              wnext                         ;
reg  [C_ADDR_WIDTH-1:0]             waddr                         ;
wire [C_DATA_WIDTH-1:0]             wmask                         ;
wire                                aw_hs                         ;
wire                                w_hs                          ;
reg  [LP_SM_WIDTH-1:0]              rstate                         = SM_RDIDLE;
reg  [LP_SM_WIDTH-1:0]              rnext                         ;
reg  [C_DATA_WIDTH-1:0]             rdata_r                       ;
wire                                ar_hs                         ;
reg  [C_ADDR_WIDTH-1:0]             raddr                         ;



reg  [ 31 : 0]                      before_out_ptr                ;
reg  [ 31 : 0]                      last_out_ptr                  ;
reg  [ 29 : 0]                      curr_length                   ;
reg                                 rece_irq_lock                 ;
reg                                 rece_ack_lock                 ;
reg  [ 31 : 0]                      int_outbuf_ptr                ;


reg                                 int_send_start                ;
reg  [ 1 :  0]                      int_send_start_dly            ;
reg                                 int_send_idle                 ;
reg                                 send_irq_lock                 ;
reg                                 send_ack_lock                 ;
reg [ 31  : 0]                      int_length                    ;
reg [ 31  : 0]                      int_inbuf_ptr                 ;
///////////////////////////////////////////////////////////////////////////////
// Begin RTL
///////////////////////////////////////////////////////////////////////////////
//=============================mAXI write fsm============================
assign awready = (~areset) & (wstate == SM_WRIDLE);
assign wready  = (wstate == SM_WRDATA);
assign bresp   = 2'b00;  // OKAY
assign bvalid  = (wstate == SM_WRRESP);
assign wmask   = { {8{wstrb[3]}}, {8{wstrb[2]}}, {8{wstrb[1]}}, {8{wstrb[0]}} };
assign aw_hs   = awvalid & awready;
assign w_hs    = wvalid & wready;

// wstate
always @(posedge aclk) begin
  if (areset)
    wstate <= SM_WRIDLE;
  else if (aclk_en)
    wstate <= wnext;
end

// wnext
always @(*) begin
  case (wstate)
    SM_WRIDLE:
      if (awvalid)
        wnext = SM_WRDATA;
      else
        wnext = SM_WRIDLE;
    SM_WRDATA:
      if (wvalid)
        wnext = SM_WRRESP;
      else
        wnext = SM_WRDATA;
    SM_WRRESP:
      if (bready)
        wnext = SM_WRIDLE;
      else
        wnext = SM_WRRESP;
    default:
      wnext = SM_WRIDLE;
  endcase
end

// waddr
always @(posedge aclk) begin
  if (aclk_en) begin
    if (aw_hs)
      waddr <= awaddr;
  end
end
//=============================AXI read fsm============================
assign arready = (~areset) && (rstate == SM_RDIDLE);
assign rdata   = rdata_r;
assign rresp   = 2'b00;  // OKAY
assign rvalid  = (rstate == SM_RDDATA);
assign ar_hs   = arvalid & arready;

// rstate
always @(posedge aclk) begin
  if (areset)
    rstate <= SM_RDIDLE;
  else if (aclk_en)
    rstate <= rnext;
end

// rnext
always @(*) begin
  case (rstate)
    SM_RDIDLE:
      if (arvalid)
        rnext = SM_RDADDR;
      else
        rnext = SM_RDIDLE;
    SM_RDADDR:
        rnext = SM_RDDATA;    
    SM_RDDATA:
      if (rready & rvalid)
        rnext = SM_RDIDLE;
      else
        rnext = SM_RDDATA;
    default:
      rnext = SM_RDIDLE;
  endcase
end


always @(posedge aclk) begin
  if (areset)
    raddr <= 0;
  else if (ar_hs)
    raddr <= araddr;
end
//=============================AXI read back reg============================
// rdata_r
always @(posedge aclk) begin
  if (areset)begin
      rdata_r<=0;
  end else begin
    if (aclk_en) begin
      case (raddr)
        //send rd reg
        LP_ADDR_SEND_CTRL: begin
          rdata_r <= {29'd0,send_irq_lock,int_send_idle,int_send_start};     
        end
        LP_ADDR_SEND_LENG: begin
          rdata_r <= int_length;     
        end
        LP_ADDR_SEND_INBUF: begin
          rdata_r <= int_inbuf_ptr;     
        end
        LP_ADDR_SEND_FIFO: begin
          rdata_r <= send_buff_statue;     
        end        
        //recevice rd reg
        LP_ADDR_RECE_STATU: begin
          rdata_r <= curr_length;     
        end
        LP_ADDR_RECE_LAST: begin
          rdata_r <= last_out_ptr;     
        end
        LP_ADDR_RECE_BEFORE: begin
          rdata_r <= before_out_ptr;     
        end
        LP_ADDR_RECE_ACK: begin
          rdata_r <= {31'd0,rece_irq_lock};     
        end
        LP_ADDR_RECE_FIFO: begin
          rdata_r <= rx_buf_status;     
        end  
        default: begin
          rdata_r <= {C_DATA_WIDTH{1'b0}};
        end
      endcase
    end
  end
end
//===================================================================
// Register logic  send 
//===================================================================
// int_send_start
always @(posedge aclk) begin
  if (areset)begin
    int_send_start <= 1'b0;
  end else begin
    if (w_hs && waddr == LP_ADDR_SEND_CTRL && wstrb[0] && wdata[0])
      int_send_start <= 1'b1;
    else if (send_init)
      int_send_start <= 1'b0;
  end
end

always @(posedge aclk) begin
  if (areset)begin
    int_send_start_dly <= 2'b0;
    end else begin
    int_send_start_dly <= {int_send_start_dly[0],int_send_start};
  end
end

assign send_start = int_send_start_dly[0] & (~int_send_start_dly[1]);


// int_send_idle
always @(posedge aclk) begin
  if (areset)begin
    int_send_idle <= 1'b0;
  end else begin
    if (send_start)
      int_send_idle <= 1'b1;
    else if (send_init==1'b1)
      int_send_idle <= 1'b0;
  end
end

//lock irq 
always @(posedge aclk) begin
  if (areset)begin
    send_irq_lock <= 1'b0;
  end else begin
    if (send_init==1'b1)
      send_irq_lock <= 1'b1;  
	else if (send_ack_lock==1'b1)
      send_irq_lock <= 1'b0; 
  end
end

// send_ack_lock
always @(posedge aclk) begin
  if (areset)begin
    send_ack_lock <= 1'b0;   
  end else begin
    if (w_hs && waddr == LP_ADDR_SEND_ACK)begin
      send_ack_lock<= 1'b1;
    end else begin
      send_ack_lock<= 1'b0;
    end       
  end
end

// int_length[32-1:0]
always @(posedge aclk) begin
  if (areset)begin
    int_length[0+:32] <= 32'd0;   
  end else begin
    if (w_hs && waddr == LP_ADDR_SEND_LENG)
      int_length[0+:32] <= (wdata[0+:32] & wmask[0+:32]) | (int_length[0+:32] & ~wmask[0+:32]);
  end
end

// int_inbuf_ptr[32-1:0]
always @(posedge aclk) begin
  if (areset)begin
    int_inbuf_ptr[0+:32] <= 32'd0;  
  end else begin
    if (w_hs && waddr == LP_ADDR_SEND_INBUF)
      int_inbuf_ptr[0+:32] <= (wdata[0+:32] & wmask[0+:32]) | (int_inbuf_ptr[0+:32] & ~wmask[0+:32]);
  end
end

assign send_length    = int_length;
assign send_inbuf_ptr = {32'h0,int_inbuf_ptr};
assign send_irq       = send_irq_lock;
assign send_ack       = send_ack_lock;
//===================================================================
// Register logic  recevice
//===================================================================
//lock irq 
always @(posedge aclk) begin
  if (areset)begin
    rece_irq_lock <= 1'b0;
  end else begin
    if (rece_ack_lock==1'b1)
        rece_irq_lock <= 1'b0; 
    else if (rece_init)
        rece_irq_lock <= 1'b1;  
  end
end


// rece_ack_lock
always @(posedge aclk) begin
  if (areset)begin
    rece_ack_lock <= 1'b0;   
  end else begin
    if (w_hs && waddr == LP_ADDR_RECE_ACK)begin
      rece_ack_lock<= 1'b1;
    end else begin
      rece_ack_lock<= 1'b0;
    end       
  end
end

//lock receive data address
always @(posedge aclk) begin
  if (areset)begin
    last_out_ptr <= 0;    
  end else if (rece_init==1'b1)begin
      last_out_ptr<= rece_outbuf_ptr;
    end       
end

always @(posedge aclk) begin
  if (areset)begin
    before_out_ptr <= 32'h40000000;   
  end else if((ar_hs) && araddr == LP_ADDR_RECE_STATU) begin
      before_out_ptr<= last_out_ptr;
    end       
end

always @(posedge aclk) begin
  if (areset)begin
    curr_length <= 30'd0;
  end else if((ar_hs) && araddr == LP_ADDR_RECE_STATU) begin
      curr_length<= last_out_ptr[29:0]-before_out_ptr[29:0];
  end          
end

assign rece_irq       = rece_irq_lock;
assign rece_ack       = rece_ack_lock;
endmodule

