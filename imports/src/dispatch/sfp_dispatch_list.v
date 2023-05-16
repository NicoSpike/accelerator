`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/18 17:48:29
// Design Name: 
// Module Name: sfp_dispatch_list
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


module sfp_dispatch_list(
  input  wire                                    ap_clk               ,
  input  wire                                    ap_rst               ,

  input  wire                                    qune_send_vaild      ,
  input  wire 		                           	 kernel_send_start    ,

  output reg 									 sfp_dispatch_en
    );

//=============================paramer define============================= 


//=============================signal define=============================

//=============================module instance============================

//===================================================================
// kernel_rece 
//===================================================================

always @ (posedge ap_clk )begin
  if (ap_rst == 1'b1)begin
      sfp_dispatch_en <=  0 ;
  end else begin
      if(kernel_send_start==1'b1)begin
        if(qune_send_vaild==1'b1)begin
        	sfp_dispatch_en <=  1'b1 ;
        end else begin
        	sfp_dispatch_en <=  1'b0 ;
        end      	
      end
  end
end 

endmodule