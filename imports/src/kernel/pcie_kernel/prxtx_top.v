`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/13/2020 09:39:08 AM
// Design Name: 
// Module Name: prxtx_top
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
module prxtx_top(
  // System Signals
  input  wire                                    ap_clk               ,
  input  wire                                    ap_rst               ,
  //send to other interface
  input   wire                                   send_start           ,  
  output  wire [64-1:0]                          sfp_rd_data          ,
  //frome other interface
  input  wire                                    sfp_wr_en            ,
  input  wire [64-1:0]                           sfp_wr_data          , 
  //read send statue
  output wire 									 rece_qune            ,               
  output wire                                    send_statue          ,
             
  // irq
  output reg                                    rece_irq              ,
  input  wire                                   rece_ack              , 
                              
  output reg                                    send_irq              ,
  input  wire                                   send_ack              ,

  output wire                                   avm_wr_ready,    
  input  wire                                   avm_wr_vaild,
  input  wire [511:0]                           avm_wr_data,        
  
  input  wire                                   avm_rd_ready,
  output wire                                   avm_rd_vaild,    
  output wire  [31:0]                           avm_rd_data,
      
  output wire  [31:0]  			                rece_fifo_usedw,
  output wire  [31:0]  			                send_fifo_usedw       
  );
//=============================paramer define============================= 


//=============================signal define=============================
wire                      send_init;
wire                      rece_init; 
wire [31:0]  			  axis_wr_data_count;
wire 					  wr_yuvdata_ready;
wire  m_axis_tvalid;
wire  m_axis_tready; 
wire[31:0]m_axis_tdata; 
wire  [31:0] rd_axi_inbuffer_cnt; 
wire 					  rd_yuvdata_ready; 
 
wire  [31:0] rece_fifo_num; 
//reg                                    avm_fifo_ready;
wire                                    avm_fifo_ready;
wire                                   avm_fifo_vaild;    
wire  [31:0]                           avm_fifo_data;
wire wr_conv_vaild;
wire [511:0]wr_conv_data;
wire wr_conv_ready;
wire wr_data_vaild;
wire rd_conv_vaild;
wire [511:0]rd_conv_data;
wire rd_conv_ready;
//===================================================================
// pcie_rece 
//===================================================================
//deep 4096
axi_data_fifo rece_axi_wdata_fifo(
  .s_axis_aresetn     (~ap_rst),
  .s_axis_aclk        (ap_clk),
  .s_axis_tvalid      (sfp_wr_en),
  .s_axis_tready      (wr_yuvdata_ready),
  .s_axis_tdata       (sfp_wr_data[63:32]),
  .m_axis_tvalid      (avm_fifo_vaild),
  .m_axis_tready      (avm_fifo_ready),
  .m_axis_tdata       (avm_fifo_data),
  .axis_wr_data_count (axis_wr_data_count),
  .axis_rd_data_count (rece_fifo_num)
  );
 assign send_statue =(axis_wr_data_count>32'd4000)?1'b0:1'b1;  

always @ (posedge ap_clk )begin
  if (ap_rst == 1'b1)begin
      rece_irq <=  0 ;
  end else begin
      if(rece_ack==1'b1)begin
        rece_irq<=1'b0;
      end else if(axis_wr_data_count>=32'd1024)begin
        rece_irq<=1'b1;          
      end                      
  end
end
//===================================================================
// 16length
//===================================================================
wire [31:0]rece_length;
assign rece_length=(rece_fifo_num[3:0]==2'b0)?rece_fifo_num[31:4]:rece_fifo_num[31:4]+1'b1;
assign rece_fifo_usedw=rece_length<<6;

always @ (posedge ap_clk )begin
  if (ap_rst == 1'b1)begin
      rece_irq <=  0 ;
  end else begin
      if(rece_ack==1'b1)begin
        rece_irq<=1'b0;
      end else if(axis_wr_data_count>=32'd1024)begin
        rece_irq<=1'b1;          
      end                      
  end
end


assign avm_fifo_ready=(rece_fifo_num==0)?1'b0:avm_rd_ready;
assign avm_rd_vaild= (rece_fifo_num==0)?avm_rd_ready:avm_fifo_vaild;
assign avm_rd_data= (rece_fifo_num==0)?32'hFFFFFFFF:avm_fifo_data;
//===================================================================
// pcie_send 
//===================================================================
//deep 512*64
axi_sdata_fifo send_axi_sdata_fifo(
  .s_axis_aresetn     (!ap_rst),
  .s_axis_aclk        (ap_clk),
  .s_axis_tvalid      (avm_wr_vaild),
  .s_axis_tready      (rd_yuvdata_ready),
  .s_axis_tdata       (avm_wr_data),
  .m_axis_tvalid      (wr_conv_vaild),
  .m_axis_tready      (wr_conv_ready),
  .m_axis_tdata       (wr_conv_data),
  .axis_wr_data_count (send_fifo_usedw),
  .axis_rd_data_count (rd_axi_inbuffer_cnt)
  );   
assign avm_wr_ready= (send_fifo_usedw>=32'd500)?1'b0:1'b1;

wr_conv wr_conv(
	.aclk 			(ap_clk),
	.aresetn		(!ap_rst),
	.s_axis_tvalid	(wr_conv_vaild),
	.s_axis_tready	(wr_conv_ready),
	.s_axis_tdata	(wr_conv_data),
	.m_axis_tvalid	(wr_data_vaild),
	.m_axis_tready	(m_axis_tready),
	.m_axis_tdata	(m_axis_tdata)
	);

assign m_axis_tvalid=wr_data_vaild&(m_axis_tdata!=32'hFFFFFFFF);


  psend_buf psend_buf(
  // System Signals
  .ap_clk           (ap_clk),
  .ap_rst           (ap_rst),
  
  .axis_data        (m_axis_tdata),
  .axis_vaild       (m_axis_tvalid),
  .axis_ready       (m_axis_tready),

  .send_start       (send_start),
  .sfp_rd_data      (sfp_rd_data),
  .rece_qune        (rece_qune)
  );

always @ (posedge ap_clk )begin
  if (ap_rst == 1'b1)begin
      send_irq <=  0 ;
  end else begin
      if(send_ack==1'b1)begin
        send_irq<=1'b0;
      end else if(rd_axi_inbuffer_cnt==32'd1)begin
        send_irq<=1'b1;          
      end                      
  end
end

//  //reg test
// reg [31:0] test_cnt;
// reg        test_flag;
// reg [3:0]  test_start_dly; 
//wire        test_posedge;
// wire       rd_axi_start;
// assign rd_axi_start=(send_fifo_usedw>=32'd1);
// always @ (posedge ap_clk or posedge ap_rst) 
// begin
//     if (ap_rst == 1'b1)begin
//         test_start_dly <=  0 ;
//     end else begin
//         test_start_dly <=  {test_start_dly,rd_axi_start};
//     end
// end   
 
// assign test_posedge=test_start_dly[2] &(~test_start_dly[3]);
 
// always @ (posedge ap_clk or posedge ap_rst) 
// begin
//     if (ap_rst == 1'b1)begin
//         test_flag <=  0 ;
//     end else if(axis_wr_data_count==32'h400) begin
//         test_flag <= 1'b0;       
//     end else if(test_posedge==1'b1) begin
//         test_flag <= 1'b1;
//     end
// end   

// always @ (posedge ap_clk or posedge ap_rst) 
// begin
//     if (ap_rst == 1'b1)begin
//         test_cnt <=  0 ;   
//     end else if(test_flag==1'b1) begin
//         test_cnt <= test_cnt+1'b1;
//     end else begin
//         test_cnt <=  0 ; 
//     end        
// end   
 
// ila_cnt ila_cnt(
// .clk         (ap_clk),
// .probe0    (send_fifo_usedw),
// .probe1    (test_posedge),
// .probe2  (test_flag),
//  .probe3  (axis_wr_data_count),
// .probe4  (test_cnt)
// );
 
(*mark_debug = "true"*)reg [31:0] send_cnt;  
(*mark_debug = "true"*)reg [31:0] receive_cnt;  
  
 always @ (posedge ap_clk or posedge ap_rst) begin
  if (ap_rst == 1'b1)begin
    send_cnt <=  0 ;
  end else if(send_start)begin
    send_cnt <=  send_cnt+1'b1 ;
  end
end   

 always @ (posedge ap_clk or posedge ap_rst) begin
  if (ap_rst == 1'b1)begin
    receive_cnt <=  0 ;
  end else if(sfp_wr_en)begin
    receive_cnt <=  receive_cnt+1'b1 ;
  end
end  
 
 
 
endmodule
