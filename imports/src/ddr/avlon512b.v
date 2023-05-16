

//////////////////////////////////////////////////////////////////-
// (c) Copyright 1984 - 2016 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//////////////////////////////////////////////////////////////////-
// ************************************************************************
//
//////////////////////////////////////////////////////////////////////////////-
// Filename:        amm_slave_0.v
// Version:         v1.0
// Description:     This is the amm slave example model.
//////////////////////////////////////////////////////////////////////////////-
// Author:      Karthee
//
// History:
//
//  Karthee      07/10/16      // First version
// ~~~~~~
`timescale 1ns/1ps
`default_nettype wire
(* DowngradeIPIdentifiedWarnings="yes" *)
module avlon512b #(
parameter                              C_HAS_FIXED_WAIT = 0,//1,
parameter                              C_HAS_RESPONSE = 1,//1,
parameter                              C_FIXED_WRITE_WAIT = 5,
parameter                              C_FIXED_READ_WAIT = 1,
parameter                              C_HAS_FIXED_READ_LATENCY = 0,//1,
parameter                              C_READ_LATENCY = 3,
parameter                              C_S_AXI_DATA_WIDTH   = 32,
parameter                              C_S_AXI_ADDR_WIDTH   = 10,
parameter                              C_USE_WSTRB          = 0,
parameter                              C_AVM_BURST_WIDTH    = 1,
parameter                              C_PROTOCOL           = 0,
parameter                              C_FAMILY            = "virtex7"
)(
    input                                   avm_clk,
    input                                   avm_resetn,
    input [C_S_AXI_ADDR_WIDTH-1:0]          avm_address,  
    input                                   avm_write, 
    input                                   avm_read, 
    input [((C_S_AXI_DATA_WIDTH / 8)-1):0]  avm_byteenable, 
    input [(C_S_AXI_DATA_WIDTH - 1):0]      avm_writedata,    
    output reg [(C_S_AXI_DATA_WIDTH - 1):0] avm_readdata, 
    output reg [1:0]                        avm_resp,
    output reg                              avm_readdatavalid,
    input                                   avm_beginbursttransfer,
    input [C_AVM_BURST_WIDTH-1:0]           avm_burstcount,
    output reg                              avm_writeresponsevalid,
    output wire                             avm_waitrequest,
    
    input                                   avm_wr_ready,    
    output                                  avm_wr_vaild,
    output   [(C_S_AXI_DATA_WIDTH - 1):0]   avm_wr_data,        
    output   [(C_S_AXI_ADDR_WIDTH - 1):0]   avm_wr_addres,
    output  reg                             wr_done,    
  
    input                                   rd_ready,
    output   [(C_S_AXI_ADDR_WIDTH - 1):0]   avm_rd_addres,     
    output                                  avm_rd_ready,
    input                                   avm_rd_vaild,    
    input   [(C_S_AXI_DATA_WIDTH - 1):0]    avm_rd_data    
    );
//=============================paramer define============================= 
   localparam IDLE            = 2'h0;
   localparam WRITE_AD_DATA   = 2'h1;
   localparam READ_ADDRESS      = 2'h2;
   localparam READ_DATA    = 2'h3;
//=============================signal define=============================
reg [C_AVM_BURST_WIDTH-1:0]         arlen_i,awlen_i;
reg avm_write_i,avm_read_i,wait_done,start,rd_lat_done,avm_write_i1;
reg [C_S_AXI_ADDR_WIDTH-1:0] avm_address_i;
reg [(C_S_AXI_DATA_WIDTH - 1):0] avm_writedata_i;
wire rd_vaild;
reg avm_waitrequest_dly; 

reg [1:0]  current_state   = IDLE;
reg [1:0]  next_state      = IDLE;
//=============================module instance============================ 
//===================================================================
// start lock address
//=================================================================== 
  always @(posedge avm_clk) begin
     if(avm_resetn == 1'b0) begin
           avm_address_i <= 0;    
     end else begin
         if(avm_write_i) begin 
           avm_address_i <= avm_address_i + 4'd8;
         end else if(rd_ready==1'b1) begin 
           avm_address_i <= avm_address_i + 4'd8;
         end else if(current_state == IDLE)begin
           avm_address_i <= {avm_address[C_S_AXI_ADDR_WIDTH-1'b1:6],3'b000};
         end
     end
  end
   
  assign avm_rd_addres=avm_address_i;
  assign avm_wr_addres=avm_address_i;  
 //===================================================================
// start read control
//=================================================================== 
assign avm_rd_ready=avm_read_i;	  
assign rd_vaild=avm_rd_vaild & avm_rd_ready;

  always @(posedge avm_clk) begin
     if(avm_resetn == 1'b0) begin
        avm_read_i <= 1'b0;
      end else begin
        if(next_state == READ_DATA && rd_vaild && arlen_i == 1) begin 
            avm_read_i <= 1'b0;
        end else if(next_state == READ_DATA && arlen_i > 0) begin 
            avm_read_i <= 1'b1;
        end
     end
   end

  always @(posedge avm_clk) begin
     if(avm_resetn == 1'b0) begin
        rd_lat_done <= 1'b0;
      end else begin
        if(next_state == READ_DATA && rd_vaild && arlen_i == 1) begin 
           rd_lat_done <= 1'b1;
        end else begin
           rd_lat_done <= 1'b0;
        end
     end
   end

  always @(posedge avm_clk) begin
     if(avm_resetn == 1'b0) begin
        arlen_i <= 0;
      end else begin
        if(next_state == READ_DATA) begin 
           if(( arlen_i > 0)&&(rd_vaild==1'b1))begin
            arlen_i <= arlen_i - 1'b1;
           end
        end else begin
            arlen_i <= avm_burstcount;
        end
     end
   end
   
  always @(posedge avm_clk) begin
     if(avm_resetn == 1'b0) begin
         avm_readdata <= 0;
         avm_readdatavalid <= 1'b0;       
     end else begin
         avm_readdata <= avm_rd_data;
         avm_readdatavalid <= rd_vaild;                                  
     end
   end   
 //===================================================================
// start write control
//=================================================================== 	
  always @(posedge avm_clk) begin
     if(avm_resetn == 1'b0) begin
        awlen_i <= 0;
      end else begin
          if(current_state == WRITE_AD_DATA)begin 
            if((avm_wr_vaild==1'b1)&&( awlen_i > 0))begin
                awlen_i <= awlen_i - 1'b1;
             end
          end else begin                  
            awlen_i <= avm_burstcount;
          end        
      end
   end


  always @(posedge avm_clk) begin
     if(avm_resetn == 1'b0) begin
        wr_done <= 0;
      end else begin
          if(current_state == WRITE_AD_DATA && awlen_i == 0)begin 
            wr_done <= 1'b1;
          end else begin            
            wr_done <= 0;
          end                 
     end
   end

   always @(posedge avm_clk) begin
     if(avm_resetn == 1'b0) begin
      avm_resp <= 2'b10;
      avm_writeresponsevalid <= 1'b0;
     end else if(wr_done == 1'b1) begin
      avm_resp <= 2'b00;
      avm_writeresponsevalid <= 1'b1;      
     end else begin
      avm_resp <= 2'b00;
      avm_writeresponsevalid <= 1'b0;     
     end
   end

   always @(posedge avm_clk) begin
       avm_write_i <= avm_write;
       avm_writedata_i <= avm_writedata;
       wait_done <= 1'b1;
   end

   always @(posedge avm_clk) begin
     if(avm_resetn == 1'b0) begin
        avm_waitrequest_dly<=1'b0;
     end else begin
       avm_waitrequest_dly <= avm_waitrequest;
     end
   end
assign avm_waitrequest=(~avm_wr_ready);   
assign avm_wr_vaild    = avm_write_i & (~avm_waitrequest_dly);
assign avm_wr_data     = avm_writedata_i;
//===================================================================
// control state 
//=================================================================== 
  // This block assigns the next state, reset is synchronous.
   always @(posedge avm_clk) begin
      if(avm_resetn == 1'b0) begin
         current_state <= IDLE;
      end else begin
         current_state <= next_state;
      end
   end
   	
 always @(*) begin
      // Setup the default values
     case (current_state)
              // If RST is asserted reset the machine
              IDLE: begin
                    start <= 1'b0;
                    if(avm_read == 1'b1) begin
                        next_state <= READ_ADDRESS;                       
     			        end else if(avm_write == 1'b1) begin
                        next_state <= WRITE_AD_DATA;                       
                    end else begin
                        next_state <= IDLE;
                    end
              end
              WRITE_AD_DATA: begin
                    if(wait_done == 1'b1 && wr_done == 1'b1)     
                        next_state <= IDLE;
                    else
                        next_state <= WRITE_AD_DATA;                      
              end
              READ_ADDRESS: begin
                    if(wait_done == 1'b1)     
                        next_state <= READ_DATA;
                    else
                        next_state <= READ_ADDRESS; 
              end
              READ_DATA: begin
                    if(rd_lat_done == 1'b1)     
                        next_state <= IDLE;
                    else
                        next_state <= READ_DATA; 
             end
     		    default: begin
                    next_state <= IDLE;           
             end
     
          endcase
         end
endmodule

