`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2018 09:13:40 AM
// Design Name: 
// Module Name: interrupt control
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

module int_ctr (
  input dma_axi_aclk,
  input dma_axi_aresetn, 
   
  input [1:0]interrupt_ack  ,
  output[1:0]pcie_interrupt ,	
 //kernel kernel    	
  input kernel_int0,
  input kernel_ack0,  
  input kernel_int1,
  input kernel_ack1
  );    

//=============================paramer define=============================  

//=============================signal define============================== 
 wire        kernel_irq0;
 wire        kernel_irq1;
 wire        dmacopy_irq0;
 wire        dmacopy_irq1;
//=============================module instance============================

//=============================kernel0 ============================
kernel_int kernel_in0(
    .dma_axi_aclk   (dma_axi_aclk),
    .dma_axi_aresetn(dma_axi_aresetn),
    .dma_ack        (interrupt_ack[0]),
    .kernel_int     (kernel_int0),
    .kernel_ack     (kernel_ack0),
    .kernel_irq     (kernel_irq0)
    );
//=============================kernel1 ============================
kernel_int kernel_in1(
    .dma_axi_aclk   (dma_axi_aclk),
    .dma_axi_aresetn(dma_axi_aresetn),
    .dma_ack        (interrupt_ack[1]),
    .kernel_int     (kernel_int1),
    .kernel_ack     (kernel_ack1),
    .kernel_irq     (kernel_irq1)
    );
assign 	pcie_interrupt = {kernel_irq1,kernel_irq0};
endmodule