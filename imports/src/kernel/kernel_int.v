`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2019 09:39:08 AM
// Design Name: 
// Module Name: kernel_int
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
module kernel_int(
  input wire dma_axi_aclk,
  input wire dma_axi_aresetn, 
  
  input wire dma_ack, 
  input wire kernel_int,
  input wire kernel_ack,  
  output wire kernel_irq
    );
//=============================paramer define=============================  
//=============================module instance============================
reg   [3:0] kernel_int_dly;
wire  kernel_int_posedge;
reg   dma_resize_ack;
reg   [3:0] kernel_resize_ack;
wire  kernel_resize_ack_posedge;
reg   [3:0] interrupt_ack;
wire  interrupt_ack_posedge;
reg   resize_interrupt;
//=============================signal define============================== 

	always @ (posedge dma_axi_aclk) begin
	   if(dma_axi_aresetn==1'b0)begin
            kernel_int_dly<=4'b0;
       end 
       else begin
            kernel_int_dly<={kernel_int_dly[2:0],kernel_int};
       end      
	end 	
	
    assign kernel_int_posedge = kernel_int_dly[2] & (~kernel_int_dly[3])	;

	always @ (posedge dma_axi_aclk) begin
	   if(dma_axi_aresetn==1'b0)begin
            interrupt_ack<=4'b0;
       end 
       else begin
            interrupt_ack<={interrupt_ack[2:0],dma_ack};
       end      
	end 
    assign  interrupt_ack_posedge = interrupt_ack[2] & (~interrupt_ack[3]);
 
	always @ (posedge dma_axi_aclk) begin
	   if(dma_axi_aresetn==1'b0)begin
            dma_resize_ack<=1'b1;
       end 
       else if(interrupt_ack_posedge)begin
            dma_resize_ack<=1'b1;
       end
       else if(kernel_resize_ack_posedge)begin
            dma_resize_ack<=1'b0;
       end      
	end 
	
	always @ (posedge dma_axi_aclk) begin
	   if(dma_axi_aresetn==1'b0)begin
            kernel_resize_ack<=4'd0;
       end 
       else begin
            kernel_resize_ack<={kernel_resize_ack[2:0],kernel_ack};
       end      
	end 

assign kernel_resize_ack_posedge = kernel_resize_ack[2]&(~kernel_resize_ack[3]);

	always @ (posedge dma_axi_aclk) begin
	   if(dma_axi_aresetn==1'b0)begin
            resize_interrupt<=1'b0;
       end 
       else if((dma_resize_ack==1'b1)&&(kernel_resize_ack_posedge==1'b1))begin
            resize_interrupt<=1'b0;
       end
       else if(kernel_int_posedge==1'b1)begin
            resize_interrupt<=1'b1;
       end     
	end     
    
 assign kernel_irq = resize_interrupt;   
 
endmodule
