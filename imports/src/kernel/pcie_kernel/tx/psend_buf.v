`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/13/2020 09:39:08 AM
// Design Name: 
// Module Name: psend_buf
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: every block have 128K space once burst 4K so the max num 32
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module psend_buf(
  // System Signals
  input wire                                     ap_clk               ,
  input wire                                     ap_rst               ,

  input  wire [31:0]                             axis_data            ,
  input  wire                                    axis_vaild           ,
  output reg                                     axis_ready           ,

  // to reg
  // output wire                                    send_buff_vaild      ,
  output reg  [31:0]                            send_buff_statue     ,
  //send to other interface
  input   wire                                   send_start           ,  
  // output  wire                                   sfp_rd_en            ,
  output  reg [64-1:0]                          sfp_rd_data          ,
  //read send statue
  output wire                                    rece_qune            
//  output wire [ 31:0]                            rece_qune_data               
);
//=============================paramer define============================= 

//=============================signal define=============================
wire        rx_wrram_en;
wire[63:0]  rx_wrram_data;
reg [15:0]  rx_wrram_addr;
reg [15:0]  rd_ddr_addr;
wire[63:0]  rd_ddr_data;
reg [1:0]   send_start_cnt;
wire        send_start_dly;
wire        send_start_posedge;
reg         send_start_syn;
reg [15:0]  send_cnt;     
//=============================module instance============================

//===================================================================
// axi write data
//===================================================================
always @ (posedge ap_clk )begin
  if (ap_rst == 1'b1)begin
      axis_ready <=  0 ;
  end else begin
      if(send_buff_statue>=32'd10)begin
        axis_ready<=1'b1;
      end else begin
        axis_ready<=1'b0;          
      end                      
  end
end
assign rx_wrram_en   =axis_vaild & axis_ready;
assign rx_wrram_data ={axis_data,32'h55aa55bc};

always @ (posedge ap_clk )begin
  if (ap_rst == 1'b1)begin
      rx_wrram_addr <=  0 ;
  end else begin
      if(rx_wrram_en==1'b1)begin
        rx_wrram_addr<=rx_wrram_addr+1'b1;       
      end                      
  end
end

ddr_ram ddr_ram(
  .clka   (ap_clk),
  .wea    (rx_wrram_en),
  .addra  (rx_wrram_addr),
  .dina   (rx_wrram_data),
  .clkb   (ap_clk),
  .addrb  (rd_ddr_addr),
  .doutb  (rd_ddr_data)
);
//===================================================================
// Statistics current queue status
//===================================================================
always @ (posedge ap_clk )begin
  if (ap_rst == 1'b1)begin
      send_start_cnt <=  0 ;
  end else begin
      if(send_start==1'b1)begin
        send_start_cnt<=1'b1;
      end else if(send_start_cnt!=0)begin
        send_start_cnt<=send_start_cnt+1'b1;          
      end                      
  end
end

assign send_start_dly =(send_start_cnt>=1)?1'b1:1'b0;

always @ (posedge ap_clk )begin
  if (ap_rst == 1'b1)begin
      send_start_syn <=  0 ;
  end else begin
      send_start_syn <=  send_start_dly ;                   
  end
end

assign send_start_posedge = send_start_dly &(!send_start_syn);

always @ (posedge ap_clk )begin
  if (ap_rst == 1'b1)begin
      send_buff_statue <= 32'd1024 ;
  end else begin
      if((rx_wrram_en==1'b1)&&(send_start_posedge==1'b1))begin
        send_buff_statue<=send_buff_statue;       
      end else if(rx_wrram_en==1'b1)begin
        send_buff_statue<=send_buff_statue-1'b1;
      end else if(send_start_posedge==1'b1)begin
        send_buff_statue<=send_buff_statue+1'b1;          
      end                     
  end
end

always @ (posedge ap_clk )begin
  if (ap_rst == 1'b1)begin
      send_cnt <=  0 ;
  end else begin
      if(send_cnt==16'd2499)begin
        send_cnt <=  0 ;
      end else begin
        send_cnt <=  send_cnt+1'b1 ;          
      end                     
  end
end
//===================================================================
// dispatch center
//===================================================================
assign rece_qune =(rx_wrram_addr==rd_ddr_addr)?1'b0:1'b1;
//assign rece_qune_data =rd_ddr_data[63:32];

always @ (posedge ap_clk )begin
  if (ap_rst == 1'b1)begin
      rd_ddr_addr <=  0 ;
  end else begin
      if(send_start==1'b1)begin
        rd_ddr_addr<=rd_ddr_addr+1'b1;
      end                      
  end
end

// always @ (posedge ap_clk )begin
//   if (ap_rst == 1'b1)begin
//       sfp_rd_en <=  1'b0;
//   end else begin 
//       if(send_start==1'b1)begin
//         sfp_rd_en <=  1'b1;
//       end else begin
//         sfp_rd_en <=  1'b0;          
//       end      
//   end
// end 

always @ (posedge ap_clk )begin
  if (ap_rst == 1'b1)begin
      sfp_rd_data <=  0;
  end else begin 
      sfp_rd_data <=  rd_ddr_data;         
  end
end 

//ila_debug ila_debug(
//.clk 	    (ap_clk),
//.probe0    (send_buff_statue),
//.probe1    (rx_wrram_en),
//.probe2    (send_start_posedge),
//.probe3    (rx_wrram_addr),
//.probe4    (rd_ddr_addr)
//);



endmodule
