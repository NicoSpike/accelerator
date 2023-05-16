`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/13/2020 09:39:08 AM
// Design Name: 
// Module Name: rece_buf
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
`default_nettype wire
module rece_buf(
  // System Signals
  input                                      ap_clk,
  input                                      ap_rst,
  input                                      rx_clk,

  input                                      rx_wrram_en,
  input  [15:0]                              rx_wrram_addr,
  input  [63:0]                              rx_wrram_data,

  output                                     send_buff_vaild,
  output reg  [31:0]                         send_buff_statue, 


  //send to other interface
  input   wire                               send_start           ,  
  // output  reg                                sfp_rd_en            ,
  output  reg [64-1:0]                       sfp_rd_data          ,
  //read send statue
  output wire                                rece_qune            
//  output wire [ 31:0]                        rece_qune_data                                 
);
//=============================paramer define============================= 

//=============================signal define=============================
reg [15:0]  rd_ddr_addr;
wire[63:0]  rd_ddr_data;
reg [1:0]   send_start_cnt;
reg         send_start_dly;
reg         send_start_dly1;
wire        send_start_posedge;
reg         send_start_syn;
reg [15:0]  send_cnt; 
reg         send_start_exp; 
wire        send_addr_posedge;  
//=============================module instance============================
ddr_ram ddr_ram(
  .clka   (rx_clk),
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
//always @ (posedge ap_clk )begin
//  if (ap_rst == 1'b1)begin
//      send_start_cnt <=  0 ;
//  end else begin
//     if(send_start_cnt!=0)begin
//        send_start_cnt<=send_start_cnt+1'b1;          
//    end  else if(send_start==1'b1)begin
//        send_start_cnt<=1'b1; 
//    end                     
//  end
//end

//assign send_start_dly =(send_start_cnt>=1)?1'b1:1'b0;
always @ (posedge ap_clk )begin
  if (ap_rst == 1'b1)begin
      send_start_exp <=  0 ;
  end else begin
      send_start_exp <=  send_start ;                             
  end
end

always @ (posedge rx_clk )begin
  if (ap_rst == 1'b1)begin
      send_start_syn <=  0 ;
      send_start_dly <=  0 ;
      send_start_dly1 <=  0 ;
  end else begin
      send_start_syn <=  send_start | send_start_exp ; 
      send_start_dly <=  send_start_syn ;
      send_start_dly1 <= send_start_dly ;                              
  end
end

assign send_start_posedge = send_start_dly &(~send_start_dly1);

always @ (posedge rx_clk )begin
  if (ap_rst == 1'b1)begin
      send_buff_statue <=  32'd1024 ;
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

assign send_buff_vaild=(send_cnt==16'd2499)?1'b1:1'b0;
//===================================================================
// dispatch center
//===================================================================
assign rece_qune =(rx_wrram_addr==rd_ddr_addr)?1'b0:1'b1;
//assign rece_qune_data =rd_ddr_data[63:32];
assign  send_addr_posedge =send_start &(~send_start_exp);

always @ (posedge ap_clk )begin
  if (ap_rst == 1'b1)begin
      rd_ddr_addr <=  0 ;
  end else begin
      if(send_start_exp==1'b1)begin
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


//ila_tx ila_tx(
//.clk 	    (rx_clk),
//.probe0    (send_buff_statue),
//.probe1    (rx_wrram_en),
//.probe2  (send_start_posedge)
//);
endmodule
