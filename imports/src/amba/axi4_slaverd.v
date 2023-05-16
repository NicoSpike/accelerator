`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/26 14:24:12
// Design Name: 
// Module Name: axi4_slaverd
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
module axi4_slaverd# (
    parameter                              C_S_AXI_DATA_WIDTH   = 32,
    parameter                              C_S_AXI_ID_WIDTH     = 1,
    parameter                              C_S_AXI_ADDR_WIDTH   = 32
    )(
    input                                   ap_clk,    
    input                                   s_axi_aclk,
    input                                   s_axi_aresetn,    
    input [C_S_AXI_ID_WIDTH-1:0]            s_axi_arid,
    input [C_S_AXI_ADDR_WIDTH-1:0]          s_axi_araddr,
    input [7:0]                             s_axi_arlen,
    input [2:0]                             s_axi_arsize,
    input [1:0]                             s_axi_arburst,
    input                                   s_axi_arvalid,
    output reg                              s_axi_arready,
    output     [C_S_AXI_ID_WIDTH-1:0]       s_axi_rid,
    output     [C_S_AXI_DATA_WIDTH-1:0]     s_axi_rdata,
    output     [1:0]                        s_axi_rresp,
    output                                  s_axi_rlast,
    output                                  s_axi_rvalid,
    input                                   s_axi_rready,

    input  wire                             rd_ready,  
    output wire                             avm_rd_ready,
    input  wire                             avm_rd_vaild,    
    input  wire [C_S_AXI_DATA_WIDTH-1:0]    avm_rd_data,
    output reg  [C_S_AXI_ADDR_WIDTH-1:0]    avm_rd_addres      
    );
//=============================paramer define============================= 
  // State Definitions
   localparam IDLE           = 2'h0;
   localparam READ_AD_DATA   = 2'h1;
   localparam READ_DATA      = 2'h2;
   localparam WAIT_RST       = 2'h3;
 // States
   reg [1:0]  current_rd_state = IDLE;
   reg [1:0]  next_rd_state = IDLE;  
//=============================signal define============================= 
reg [7:0]                 avm_rdburstcount;
reg [8:0]                 length_cnt;
reg [8:0]                 slave_cnt;
reg [C_S_AXI_ID_WIDTH-1:0]read_id;
reg [3:0]                 rst_cnt;
wire                      axi_rstn;
wire                      m_axis_tvalid;
wire                      m_axis_tready; 
wire[31:0]                m_axis_tdata; 
wire[31:0]                axis_wr_data_count;
reg [C_S_AXI_ADDR_WIDTH-1:0]    axi_rd_addres;
reg avm_rd_en;
reg [3:0] avm_rd_reg;
wire      avm_rstn;
wire      avm_rd_lock;
reg       avm_rd_vaild_i; 
reg [31:0]avm_rd_data_i; 
reg       avm_rd_ready_i;
//===================================================================
// control state
//===================================================================
always @(posedge s_axi_aclk) begin
   if(s_axi_aresetn == 1'b0) begin
      current_rd_state <= 0;
   end else begin
     current_rd_state  <= next_rd_state;
   end
end


always @(*) begin
   if (s_axi_aresetn == 1'b0) begin
      next_rd_state <= IDLE;
      s_axi_arready <= 1'b1;
      read_id <= 0;
   end
   else begin 
      case (current_rd_state)
          IDLE: begin
              if (s_axi_arvalid == 1'b1 & s_axi_rready==1'b1)begin // Master has put addr and data
              // in this state i can assert the awready on AXI side and free it up
                 next_rd_state <= READ_DATA;
              //   avm_wr_byteenable <= s_axi_wstrb; // latch the wstrb
                 read_id <= s_axi_arid;
                 s_axi_arready <= 1'b1;
              end
              else if(s_axi_arvalid == 1'b1)begin  
              // in this state i can assert the awready on AXI side and free it up
                 next_rd_state <= READ_AD_DATA;
              //   avm_wr_byteenable <= s_axi_wstrb; // latch the wstrb
                 read_id <= s_axi_arid;
                 s_axi_arready <= 1'b1;                
              end
              else begin
                 next_rd_state <= IDLE;
              end
          end

          READ_AD_DATA: begin // when address is accepted and data is awaited
                 s_axi_arready <= 1'b0;
              if (s_axi_rready == 1'b1) begin
                 next_rd_state <= READ_DATA;
              end
              else begin
                 next_rd_state <= READ_AD_DATA;
              end
     
          end
          READ_DATA: begin 
                 s_axi_arready <= 1'b0;               
                 if (s_axi_rvalid == 1'b1 && s_axi_rlast == 1'b1 && s_axi_rready == 1'b1) begin
                    next_rd_state <= WAIT_RST;
                 end
                 else begin
                    next_rd_state <= READ_DATA;
                 end
          end
          WAIT_RST: begin
                 if (axi_rstn==1'b0) begin
                    next_rd_state <= IDLE;
                    s_axi_arready <= 1'b1;
                 end
                 else begin
                    next_rd_state <= WAIT_RST;
                    s_axi_arready <= 1'b0;
                 end
          end
        default: begin
                 next_rd_state <= IDLE;

          end
        endcase
    end
end
//===================================================================
// to extra interface
//===================================================================
always @(posedge s_axi_aclk) begin
   if(s_axi_aresetn == 1'b0) begin
      axi_rd_addres <= 0;
   end else begin
     if(s_axi_arvalid & s_axi_arready) begin
         axi_rd_addres <= s_axi_araddr;                       
     end
   end
end

always @(posedge s_axi_aclk) begin
   if(s_axi_aresetn == 1'b0) begin
      avm_rd_en <= 0;
   end else begin
     if (s_axi_rlast)begin
         avm_rd_en <= 1'b0;    
     end else if(s_axi_arvalid & s_axi_arready) begin
         avm_rd_en <= 1'b1;                         
     end
   end
end

assign m_axis_tready =((current_rd_state==READ_AD_DATA)||(current_rd_state==READ_DATA))?s_axi_rready:1'b0;
assign s_axi_rvalid =((current_rd_state==READ_AD_DATA)||(current_rd_state==READ_DATA))?m_axis_tvalid:1'b0;
assign s_axi_rdata  =m_axis_tdata;
assign s_axi_rlast  =(s_axi_rvalid  && s_axi_rready && length_cnt==1);
assign s_axi_rresp  =2'b00;
assign s_axi_rid    =read_id;
//===================================================================
// lock length
//===================================================================
always @(posedge s_axi_aclk) begin
   if(s_axi_aresetn == 1'b0) begin
      length_cnt <= 0;
   end else begin
     if(s_axi_arvalid & s_axi_arready) begin
         length_cnt <= s_axi_arlen+1'b1;         
     end else if (s_axi_rvalid & s_axi_rready)begin
         length_cnt <= length_cnt-1'b1;                 
     end
   end
end

always @(posedge s_axi_aclk) begin
   if(s_axi_aresetn == 1'b0) begin
      rst_cnt <= 0;
   end else begin
     if(s_axi_rlast) begin
         rst_cnt<=1;         
     end else if (rst_cnt!=0)begin
         rst_cnt <= rst_cnt+1'b1;                 
     end
   end
end
assign axi_rstn=(rst_cnt>=4'd5)?1'b0:1'b1;
//===================================================================
// Cross clock processing
//===================================================================
axi_rddata axi_rddata_fifo(
  .s_axis_aresetn     (avm_rstn),
  .s_axis_aclk        (ap_clk),
  .s_axis_tvalid      (avm_rd_vaild & avm_rd_ready),
  .s_axis_tready      (),
  .s_axis_tdata       (avm_rd_data),
  
  .m_axis_aclk        (s_axi_aclk ),
  .m_axis_tvalid      (m_axis_tvalid),
  .m_axis_tready      (m_axis_tready),
  .m_axis_tdata       (m_axis_tdata),
  .axis_wr_data_count (axis_wr_data_count)
  );

assign  avm_rstn = s_axi_aresetn & axi_rstn;
always @(posedge ap_clk) begin
   if(avm_rstn == 1'b0) begin
      avm_rd_reg <= 0;
   end else begin
      avm_rd_reg <= {avm_rd_reg[2:0],avm_rd_en};
   end
end  
  
assign avm_rd_lock = avm_rd_reg[2] & (!avm_rd_reg[3]); 
 
always @(posedge ap_clk) begin
   if(avm_rstn == 1'b0) begin
      avm_rd_addres <= 0;
   end else if(avm_rd_lock==1'b1) begin
      avm_rd_addres <= {axi_rd_addres[C_S_AXI_ADDR_WIDTH-1'b1:6],3'b000};
   end else if(rd_ready==1'b1 & axi_rd_addres[31:24]!=8'h0) begin
      avm_rd_addres <= avm_rd_addres+4'd8;
   end    
end   
 
always @(posedge ap_clk) begin
   if(s_axi_aresetn == 1'b0) begin
      slave_cnt <= 0;
   end else begin
     if(avm_rd_lock) begin
         slave_cnt <= length_cnt;         
     end else if (avm_rd_vaild & avm_rd_ready)begin
         slave_cnt <= slave_cnt-1'b1;                 
     end
   end
end 
 
assign  avm_rd_ready=(axis_wr_data_count>=8090)?1'b0:avm_rd_reg[3]&(slave_cnt>=9'd1);
endmodule